args:
args.stdenv.mkDerivation {
    name = args.jedit.name+"_startscript";

    java = args.jre+"/bin/java";
    jeditjar = args.jedit+"/lib/jedit.jar";

    phases = "buildPhase";

    buildPhase = "
ensureDir \$out/bin
cat > \$out/bin/${args.jedit.name} << EOF
#!/bin/sh
exec $java -jar $jeditjar \\$*
EOF
  chmod +x \$out/bin/${args.jedit.name}
";
}
