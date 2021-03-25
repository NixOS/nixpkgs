# Java {#sec-language-java}

Ant-based Java packages are typically built from source as follows:

```nix
stdenv.mkDerivation {
  name = "...";
  src = fetchurl { ... };

  nativeBuildInputs = [ jdk ant ];

  buildPhase = "ant";
}
```

Note that `jdk` is an alias for the OpenJDK (self-built where available,
or pre-built via Zulu). Platforms with OpenJDK not (yet) in Nixpkgs
(`Aarch32`, `Aarch64`) point to the (unfree) `oraclejdk`.

JAR files that are intended to be used by other packages should be
installed in `$out/share/java`. JDKs have a stdenv setup hook that add
any JARs in the `share/java` directories of the build inputs to the
`CLASSPATH` environment variable. For instance, if the package `libfoo`
installs a JAR named `foo.jar` in its `share/java` directory, and
another package declares the attribute

```nix
buildInputs = [ libfoo ];
nativeBuildInputs = [ jdk ];
```

then `CLASSPATH` will be set to
`/nix/store/...-libfoo/share/java/foo.jar`.

Private JARs should be installed in a location like
`$out/share/package-name`.

If your Java package provides a program, you need to generate a wrapper
script to run it using a JRE. You can use `makeWrapper` for this:

```nix
nativeBuildInputs = [ makeWrapper ];

installPhase = ''
  mkdir -p $out/bin
  makeWrapper ${jre}/bin/java $out/bin/foo \
    --add-flags "-cp $out/share/java/foo.jar org.foo.Main"
'';
```

Since the introduction of the Java Platform Module System in Java 9,
Java distributions typically no longer ship with a general-purpose JRE:
instead, they allow generating a JRE with only the modules required for
your application(s). Because we can't predict what modules will be
needed on a general-purpose system, the default jre package is the full
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
  ...
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
nativeBuildInputs = [ gcj ant ];
```

Here, Ant will automatically use `gij` (the GNU Java Runtime) instead of
the OpenJRE.
