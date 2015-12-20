{ stdenv, lib, requireFile, fetchurl, libX11, libXext, libXcursor, 
  libXrandr, libjack2, alsaLib, personal_sha256, 
  ... }:

stdenv.mkDerivation rec {
  name = "renoise_" + version ;
  version = "beta_4";

  buildInputs = [ libX11 libXext libXcursor libXrandr alsaLib libjack2 ];

  src = let name = if builtins.currentSystem == "x86_64-linux" then
                     "rns_3_1_0b4_linux_x86_64.tar.gz"
                   else 
                     "rns_3_1_0b4_linux_x86.tar.gz";
            message = ''
              please go to http://backstage.renoise.com/frontend/app/index.html#/login and download the binary.
              import the binary by : nix-store --add-fixed sha256 ${name}
              find out the hash by : shasum -a 256 ${name}
              and set the hash in your /etc/nixos/configuration.nix or ~/.nixpkgs/config.nix
              systemPackages = [ pkgs.renoise.override { personal_sha256 = "the_sum" } ]
              '';
        in 
          requireFile {
            name = name;
            sha256 = personal_sha256;
            message = message;
          };

  installPhase = ''
    cp -r Resources $out

    mkdir -p $out/lib/

    mv $out/AudioPluginServer* $out/lib/

    cp renoise $out/renoise

    for path in ${toString buildInputs}; do
      ln -s $path/lib/*.so* $out/lib/
    done

    ln -s ${stdenv.cc.cc}/lib/libstdc++.so.6 $out/lib/

    mkdir $out/bin
    ln -s $out/renoise $out/bin/renoise

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/lib $out/renoise
  '';

  meta = with stdenv.lib; {
    description = "modern tracker-based DAW";
    homepage = http://www.renoise.com/;
    license = licenses.unfree;
    maintainers = [ maintainers.palo ];
  };
}
