args: with args;
stdenv.mkDerivation ( rec {
  pname = "skype";
  version = "2.0.0.72";
  name = "skype-2.0";

  src = fetchurl {
    url = http://download.skype.com/linux/skype_static-2.0.0.72.tar.bz2;
    sha256 = "2f37963e8f19c0ec5efd8631abe9633b6551f09dee024460c40fad10728bc580";
    name = "${pname}_static-${version}.tar.bz2";
  };

  buildInputs = [
    alsaLib 
    glibc 
    gcc.gcc
    libSM 
    libICE 
    libXi 
    libXv
    libXScrnSaver
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
