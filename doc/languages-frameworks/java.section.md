# Java {#sec-language-java}

Ant-based Java packages are typically built from source as follows:

```nix
stdenv.mkDerivation {
  pname = "...";
  version = "...";

  src = fetchurl {
    # ...
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook # removes timestamp metadata from jar files
  ];

  buildPhase = ''
    runHook preBuild
    ant # build the project using ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # copy generated jar file(s) to an appropriate location in $out
    install -Dm644 build/foo.jar $out/share/java/foo.jar

    runHook postInstall
  '';
}
```

Note that `jdk` is an alias for the OpenJDK (self-built where available,
or pre-built via Zulu).

Also note that not using `stripJavaArchivesHook` will likely cause the
generated `.jar` files to be non-deterministic, which is not optimal.
Using it, however, does not always guarantee reproducibility.

JAR files that are intended to be used by other packages should be
installed in `$out/share/java`. JDKs have a `stdenv` setup hook that adds
any JARs in the `share/java` directories of the build inputs to the
`CLASSPATH` environment variable. For instance, if the package `libfoo`
installs a JAR named `foo.jar` in its `share/java` directory, and
another package declares the attribute

```nix
{
  buildInputs = [ libfoo ];
  nativeBuildInputs = [ jdk ];
}
```

then `CLASSPATH` will be set to
`/nix/store/...-libfoo/share/java/foo.jar`.

Private JARs should be installed in a location like
`$out/share/package-name`.

If your Java package provides a program, you need to generate a wrapper
script to run it using a JRE. You can use `makeWrapper` for this:

```nix
{
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/foo \
      --add-flags "-cp $out/share/java/foo.jar org.foo.Main"

    runHook postInstall
  '';
}
```

Since the introduction of the Java Platform Module System in Java 9,
Java distributions typically no longer ship with a general-purpose JRE:
instead, they allow generating a JRE with only the modules required for
your application(s). Because we can't predict what modules will be
needed on a general-purpose system, the default `jre` package is the full
JDK. When building a minimal system/image, you can override the
`modules` parameter on `jre_minimal` to build a JRE with only the
modules relevant for you:

```nix
let
  my_jre = pkgs.jre_minimal.override {
    modules = [
      # The modules used by 'something' and 'other' combined:
      "java.base"
      "java.logging"
    ];
  };
  something = (pkgs.something.override { jre = my_jre; });
  other = (pkgs.other.override { jre = my_jre; });
in
<...>
```

You can also specify what JDK your JRE should be based on, for example
selecting a 'headless' build to avoid including a link to GTK+:

```nix
{ my_jre = pkgs.jre_minimal.override { jdk = jdk11_headless; }; }
```

Note all JDKs passthru `home`, so if your application requires
environment variables like `JAVA_HOME` being set, that can be done in a
generic fashion with the `--set` argument of `makeWrapper`:

```bash
--set JAVA_HOME ${jdk.home}
```

It is possible to use a different Java compiler than `javac` from the
OpenJDK. For instance, to use the GNU Java Compiler:

```nix
{
  nativeBuildInputs = [
    gcj
    ant
  ];
}
```

Here, Ant will automatically use `gij` (the GNU Java Runtime) instead of
the OpenJRE.

## Package Java libraries with `buildJavaPackage` {#sec-java-buildJavaPackage}

Package Java software that does not require Maven, Gradle, or Ant:

```nix
{
  lib,
  buildJavaPackage,
  fetchFromGitHub,
  jspecify,
}:

buildJavaPackage (finalAttrs: {
  pname = "jsoup";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "jhy";
    repo = "jsoup";
    rev = "jsoup-${finalAttrs.version}";
    hash = "sha256-Zkq2W9p8AAgeuWxze1QJfmmzwLPz4iNm6UggW5sZmJ0=";
  };

  classpath = [ jspecify ];

  meta = {
    homepage = "https://jsoup.org/";
    description = "Java HTML parser";
    license = lib.licenses.mit;
  };
})
```

`buildJavaPackage` compiles `.java` source files with `javac`.
It bundles compiled classes and resources into a deterministic JAR archive with `jar`.
The builder installs `${jarName}-${version}.jar` and a `${jarName}.jar` symlink into `$out/share/java/`.

### Attribute reference {#sec-java-buildJavaPackage-attributes}

`buildJavaPackage` accepts standard `stdenvNoCC.mkDerivation` attributes, plus:

* `jdk` (optional, default `buildPackages.jdk`): Compiler package for `nativeBuildInputs`.
* `javaRelease` (optional, default `8`): Target Java release version passed to `javac --release`. Set to `null` to omit `--release` and pass custom `-source` and `-target` flags in `javacFlags`.
* `encoding` (optional, default `"UTF-8"`): Source file encoding passed to `javac -encoding`.
* `javaSourceDir` (optional, default `"src/main/java"`): Source directory relative to the repository root.
* `resourcesDir` (optional, default `"src/main/resources"`): Resource directory to include in the JAR.
* `excludeSourcePatterns` (optional, default `[ ]`): File patterns to exclude when compiling.
* `jarName` (optional, default `finalAttrs.pname`): Output JAR file name without the `.jar` extension.
* `javacFlags` (optional, default `[ ]`): Extra flags passed to `javac`.
* `classpath` (optional, default `[ ]`): Java packages whose JAR files are added to `buildInputs` and the compilation classpath.
* `propagatedClasspath` (optional, default `[ ]`): Java dependencies added to `propagatedBuildInputs` for downstream packages.
* `extraClasspath` (optional, default `""`): String appended to the `-classpath` compiler argument.
