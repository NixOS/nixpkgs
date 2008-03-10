args: with args;
stdenv.mkDerivation ( rec {
  pname = "skype";
  version = "1.4.0.118";
  name = "skype-1.4";

  src = fetchurl {
    url = http://www.skype.com/go/getskype-linux-static;
    sha256 = "1293f54811a36b2a1b83c56a4ad2844e58c753fe39b61422fac66b001d0f9e0c";
    name = "${pname}_static-${version}.tar.bz2";
  };

  buildInputs = [
    alsaLib 
    glibc 
    gcc.gcc
    libSM 
    libICE 
    libXi 
    libXrender 
    libXrandr 
    libXfixes 
    libXcursor 
    libXinerama 
    freetype 
    fontconfig 
    libXext 
    libX11 
    fontconfig 
    libsigcxx 
  ];

  phases = "unpackPhase installPhase";
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
})
