{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  fetchFromGitHub,
  jdk,
  jdk8,
  jre,
  runCommand,
  temurin-bin-8,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "antlr";
  version = "3.5.2";
  jar = fetchurl {
    url = "https://www.antlr3.org/download/antlr-${version}-complete.jar";
    sha256 = "0srjwxipwsfzmpi0v32d1l5lzk9gi5in8ayg33sq8wyp8ygnbji6";
  };
  antlrSources = fetchurl {
    url = "https://repo1.maven.org/maven2/org/antlr/antlr/${version}/antlr-${version}-sources.jar";
    hash = "sha256-4o3u9At0BAH31wdd4k/5VFG916m6zj6YoTib/YoVTTQ=";
  };

  src = fetchFromGitHub {
    owner = "antlr";
    repo = "antlr3";
    rev = "5c2a916a10139cdb5c7c8851ee592ed9c3b3d4ff";
    sha256 = "1i0w2v9prrmczlwkfijfp4zfqfgrss90a7yk2hg3y0gkg2s4abbk";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/antlr3/raw/f1bb8d639678047935e1761c3bf3c1c7da8d0f1d/f/0006-antlr3memory.hpp-fix-for-C-20-mode.patch";
      sha256 = "0apk904afjqbad6c7z9r72a9lkbz69vwrl8j2a6zgxjn8dfb2p8b";
    })
  ];

  legacyJdk =
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64 then temurin-bin-8 else jdk8;
  nativeBuildInputs = [
    jdk
    legacyJdk
  ];
  buildPhase = ''
    runHook preBuild

    mkdir -p java-src classes
    (cd java-src; ${jdk}/bin/jar xf ${antlrSources})

    sed -i 's/\r$//' java-src/org/antlr/{Tool.java,tool/{CompositeGrammar,Rule}.java,grammar/v3/DefineGrammarItemsWalker.java}

    patch -l -p1 -d java-src < ${./reproducible-codegen.patch}

    ${legacyJdk}/bin/javac -source 1.5 -target 1.5 -Xlint:-options \
      -cp "${jar}" \
      -d classes \
      java-src/org/antlr/Tool.java \
      java-src/org/antlr/tool/CompositeGrammar.java \
      java-src/org/antlr/tool/Rule.java \
      java-src/org/antlr/grammar/v3/DefineGrammarItemsWalker.java

    cp "${jar}" "antlr-${version}-complete.jar"
    (cd classes; find org -type f -name '*.class' | LC_ALL=C sort) |
    while IFS= read -r cls; do
      ${jdk}/bin/jar \
        --update \
        --file "antlr-${version}-complete.jar" \
        --date 1980-01-01T00:00:02Z \
        -C classes "$cls"
    done

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p "$out"/{lib/antlr,bin,include}
    cp "antlr-${version}-complete.jar" "$out/lib/antlr/antlr-${version}-complete.jar"
    cp runtime/Cpp/include/* $out/include/

    echo "#! ${stdenv.shell}" >> "$out/bin/antlr"
    echo "'${jre}/bin/java' -cp '$out/lib/antlr/antlr-${version}-complete.jar' -Xms200M -Xmx400M org.antlr.Tool \"\$@\"" >> "$out/bin/antlr"

    chmod a+x "$out/bin/antlr"
    ln -s "$out/bin/antlr"{,3}
  '';

  passthru.tests.reproducibility =
    runCommand "antlr3-reproducibility-test"
      {
        nativeBuildInputs = [ jdk ];
        antlrPkg = finalAttrs.finalPackage;
        originalJar = jar;
      }
      ''
        export LC_ALL=C
        mkdir check
        (
          cd check
          printf '%s\n' 'parser grammar S;' 'a : B ;' 'b : B ;' > S.g
          printf '%s\n' 'parser grammar T;' 'c : B ;' 'd : B ;' > T.g
          printf '%s\n' 'grammar M;' 'import S,T;' 's : a b c d ;' "B : 'b' ;" > M.g

          printf '%s\n' \
            'grammar Rewrite;' \
            'options { output=AST; }' \
            'a : ID INT -> ^(INT ID);' \
            "ID : ('a'..'z')+;" \
            "INT : ('0'..'9')+;" > Rewrite.g

          printf '%s\n' \
            'grammar NestedRewrite;' \
            'options { output=AST; }' \
            'a : A B C D -> (A B (C D)?)?;' \
            "A : 'a'; B : 'b'; C : 'c'; D : 'd';" > NestedRewrite.g

          printf '%s\n' \
            'grammar ThrowsOrder;' \
            '@header {import java.io.IOException; import java.sql.SQLException; import java.util.concurrent.TimeoutException;}' \
            'a throws IOException, SQLException, TimeoutException : ID;' \
            "ID : 'a';" > ThrowsOrder.g

          for run in 1 2 3; do
            mkdir "run-$run"
            cp ./*.g "run-$run/"
            (
              cd "run-$run"
              export TZ=$([ "$run" -eq 1 ] && echo UTC || echo Pacific/Honolulu)
              "$antlrPkg/bin/antlr3" -lib . M.g
              "$antlrPkg/bin/antlr3" Rewrite.g
              "$antlrPkg/bin/antlr3" NestedRewrite.g
              "$antlrPkg/bin/antlr3" ThrowsOrder.g
              test -s MParser.java
              test -s RewriteParser.java
              test -s NestedRewriteParser.java
              test -s ThrowsOrderParser.java
              grep -q '1980-01-01 00:00:00' RewriteParser.java
              grep -Eq 'a\(\)[[:space:]]+throws IOException, SQLException, TimeoutException, RecognitionException' ThrowsOrderParser.java
              sha256sum -- *.java *.tokens > "../manifest-$run"
            )
          done

          cmp manifest-1 manifest-2
          cmp manifest-1 manifest-3

          mkdir original updated
          (cd original; ${jdk}/bin/jar xf "$originalJar" org/antlr/runtime/ANTLRStringStream.class)
          (cd updated; ${jdk}/bin/jar xf "$antlrPkg/lib/antlr/antlr-${finalAttrs.version}-complete.jar" org/antlr/runtime/ANTLRStringStream.class)
          cmp original/org/antlr/runtime/ANTLRStringStream.class updated/org/antlr/runtime/ANTLRStringStream.class

          cd run-1

          printf '%s\n' \
            'import org.antlr.runtime.*;' \
            'class Smoke {' \
            '  public static void main(String[] args) throws Exception {' \
            '    RewriteParser parser = new RewriteParser(new CommonTokenStream(new RewriteLexer(new ANTLRStringStream("abc123"))));' \
            '    if (!"(123 abc)".equals(((org.antlr.runtime.tree.Tree) parser.a().getTree()).toStringTree())) throw new AssertionError();' \
            '    if (parser.getNumberOfSyntaxErrors() != 0) throw new AssertionError();' \
            '  }' \
            '}' > Smoke.java
          ${jdk}/bin/javac -cp "$antlrPkg/lib/antlr/antlr-${finalAttrs.version}-complete.jar" *.java
          ${jdk}/bin/java -cp ".:$antlrPkg/lib/antlr/antlr-${finalAttrs.version}-complete.jar" Smoke

          ${jdk}/bin/javap -c -p -classpath "$antlrPkg/lib/antlr/antlr-${finalAttrs.version}-complete.jar" \
            org.antlr.tool.CompositeGrammar > composite.javap
          ${jdk}/bin/javap -c -p -classpath "$antlrPkg/lib/antlr/antlr-${finalAttrs.version}-complete.jar" \
            org.antlr.tool.Rule > rule.javap
          ${jdk}/bin/javap -c -p -classpath "$antlrPkg/lib/antlr/antlr-${finalAttrs.version}-complete.jar" \
            org.antlr.grammar.v3.DefineGrammarItemsWalker > walker.javap
          test "$(grep -c 'class java/util/LinkedHashSet' composite.javap)" -ge 1
          grep -q 'class java/util/LinkedHashSet' rule.javap
          ${jdk}/bin/javap -verbose -classpath "$antlrPkg/lib/antlr/antlr-${finalAttrs.version}-complete.jar" org.antlr.Tool | grep -q 'major version: 49'
          test "$(grep -c 'new .*// class java/util/LinkedHashSet' walker.javap)" -eq 4
          sed -n '/ throwsSpec() /,/^$/p' walker.javap | grep 'new .*// class java/util/LinkedHashSet' > /dev/null
        )

        cp check/manifest-1 "$out"
      '';

  inherit jre;

  meta = {
    description = "Powerful parser generator";
    longDescription = ''
      ANTLR (ANother Tool for Language Recognition) is a powerful parser
      generator for reading, processing, executing, or translating structured
      text or binary files. It's widely used to build languages, tools, and
      frameworks. From a grammar, ANTLR generates a parser that can build and
      walk parse trees.
    '';
    homepage = "https://www.antlr.org/";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.workflow ];
  };
})
