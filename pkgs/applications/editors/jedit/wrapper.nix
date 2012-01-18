args: with args;
stdenv.mkDerivation {
    name = jedit.name+"_startscript";

    java = jre+"/bin/java";
    jeditjar = jedit+"/lib/jedit.jar";

    phases = "buildPhase";

    buildPhase = "
mkdir -p \$out/bin
cat > \$out/bin/${jedit.name} << EOF
#!/bin/sh
exec $java -jar $jeditjar \\$*
EOF
  chmod +x \$out/bin/${jedit.name}
";
}
