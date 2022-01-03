{ lib, thunderbird, sequoia-octopus-librnp }:
let
  originalPackage = thunderbird;

  # We use `overrideAttrs` instead of defining a new `mkDerivation` to keep
  # the original package's `output`, `passthru`, and so on.
  thunderbird-sequoia = originalPackage.overrideAttrs (old: rec {
    pname = "thunderbird-sequoia";
    version = "${old.version}+${sequoia-octopus-librnp.version}";

    meta = with lib; {
      description = "Thunderbird with the Sequoia OpenPGP backend";
      homepage = "https://gitlab.com/sequoia-pgp/sequoia-octopus-librnp";
      license = old.meta.license;
      maintainers = with maintainers; [ puzzlewolf ];
    };

    propagatedBuildInputs = [
      sequoia-octopus-librnp
    ];

    buildCommand = ''
      cp -a "${originalPackage}" "$out"

      # Replace librnp.so
      chmod +w $out/lib/thunderbird
      rm $out/lib/thunderbird/librnp.so
      ln -s ${sequoia-octopus-librnp}/lib/libsequoia_octopus_librnp.so \
        $out/lib/thunderbird/librnp.so
      chmod -w $out/lib/thunderbird

      # Thunderbird looks for shared libraries in the same directory as its binary,
      # so we need to fix the wrappers to run the binary from this derivation
      # so that it actually finds new librnp.so.
      chmod +w $out/bin
      for file in \
        "$out/bin/thunderbird" "$out/bin/.thunderbird-wrapped_" "$out/bin/.thunderbird-old"
      do
        substituteInPlace "$file" --replace "${originalPackage}" "$out"
      done
      chmod -w $out/bin
    '';

  });
in
thunderbird-sequoia
