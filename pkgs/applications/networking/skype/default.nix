args:
args.stdenv.mkDerivation {
  name = "skype-1.4";

  src = args.fetchurl {
    url = http://www.skype.com/go/getskype-linux-static;
    sha256 = "0k71byzaipmw8lb92aad4qyh9rk0fnn3za74v1h268h09gkkd8mz";
    name = "skype_static-1.4.0.99.tar.bz2";
  };

  buildInputs =(with args; [alsaLib glibc libSM libICE libXi libXrender libXrandr libXfixes 
      libXcursor libXinerama freetype fontconfig libXext libX11 
    fontconfig libXinerama libsigcxx gcc41.gcc ]);

  phases = "installPhase";
  installPhase ="

    ensureDir \$out/{opt/skype/,bin};
    cp -r * \$out/opt/skype/;
    cat >\$out/bin/skype << EOF
#!/bin/sh
      \$out/opt/skype/skype
EOF
    chmod +x \$out/bin/skype

fullPath=
for i in \$buildInputs; do
    fullPath=\$fullPath\${fullPath:+:}\$i/lib
done
          
    echo patchelf --interpreter \"\$(cat \$NIX_GCC/nix-support/dynamic-linker)\" \\
    --set-rpath \$fullPath \\
    \$out/opt/skype/skype
    patchelf --interpreter \"\$(cat \$NIX_GCC/nix-support/dynamic-linker)\" \\
    --set-rpath \$fullPath \\
    \$out/opt/skype/skype
  ";

  meta = {
      description = "A P2P-VoiceIP client";
      homepage = http://www.skype.com;
      license = "skype-eula";
  };
}
