args: with args;
stdenv.mkDerivation {
  name = "nix-eclipse-runner-script";

  phases = "installPhase";
  installPhase = ''
    ensureDir $out/bin
    target=$out/bin/nix-run-eclipse
    cat > $target << EOF
    #!/bin/sh
    export PATH=${jre}/bin:$PATH
    export LD_LIBRARY_PATH=${glib}/lib:${gtk}/lib:${libXtst}/lib
    # If you run out of XX space try these? -vmargs -Xms512m -Xmx2048m -XX:MaxPermSize=256m
    exec "\$@"
    EOF
    chmod +x $target
  '';

  meta = { 
    description = "provide environment to run Eclipse";
    longDescription = ''
      Is there one distribution providing support for up to date Eclipse installations?
      There are various reasons why not.
      Installing binaries just works. Get Eclipse binaries form eclipse.org/downloads
      install this wrapper then run Eclipse like this:
      nix-run-eclipse $PATH_TO_ECLIPSE/eclipse/eclipse
      and be happy. Everything works including update sites.
    '';
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}
