{ stdenv, lib, requireFile, demo, fetchurl, libX11, libXext, libXcursor, libXrandr, alsaLib, ... }:

let
  unlines = strs: lib.concatStrings ((map (x: x + "\n")) strs);

  renoise =
    stdenv.mkDerivation {
      name = "renoise";

      phases = "unpackPhase installPhase";

      src =
        if builtins.currentSystem == "x86_64-linux" then
          if demo then
            fetchurl {
              url = "http://files.renoise.com/demo/Renoise_3_0_1_Demo_x86_64.tar.bz2";
              sha256 = "1q7f94wz2dbz659kpp53a3n1qyndsk0pkb29lxdff4pc3ddqwykg";
            }
          else
            requireFile {
              url = "http://backstage.renoise.com/frontend/app/index.html#/login";
              name = "rns_3_0_1_linux_x86_64.tar.gz";
              sha256 = "0n23m0f3pkwgicgvvg4hr7wa1jdk0py91fndda5986ri0km4j6af";
            }
        else throw "haven't written this for systems besides 64-bit linux";

      unpackPhase = ''
        tar -xf $src
      '';

      installPhase = ''
        cd ${if demo then "Renoise_3_0_1_Demo_x86_64" else "rns_3_0_1_linux_x86_64"}

        mkdir -p $out/
        cp -r ./Resources/* $out/
        mkdir -p $out/lib/
        mv $out/AudioPluginServer_x86_64 $out/lib/
        cp renoise $out/renoise
      '';

      meta = {
        description = "modern tracker-based DAW";
        homepage = http://www.renoise.com/;
        license = stdenv.lib.licenses.unfree;
      };
    };

  # fill the base derivation's resource directory up with 
  # the necessary library files, patch the binary, and make a caller
  # function in $out/bin
  makeConfortable = { deriv, bin, resources }:
    stdenv.mkDerivation rec {
      inherit (deriv) name meta;

      src = deriv;
      phases = "installPhase";
      libs = [libX11 libXext libXcursor libXrandr alsaLib];

      inherit resources bin;

      installPhase = ''
        # copy source tree, fill up resources
        mkdir -p $out
        mkdir -p $out/$resources
        ${unlines (map (lib: "ln -s ${lib}/lib/*.so* $out/$resources/") libs)}

        ln -s ${stdenv.cc.cc}/lib/libstdc++.so.6 $out/$resources/

        cp -r $src/* $out/
        
        # patching file
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/$resources $out/$bin

        # distributing executable
        mkdir $out/bin
        ln -s $out/$bin $out/bin/renoise
      '';
    };
in
  makeConfortable {
    deriv = renoise;
    bin = "renoise";
    resources = "lib";
  }
