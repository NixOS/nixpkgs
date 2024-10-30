{
  lib,
  callPackage,
  fetchurl,
}:
let
  makeDocBookVersion =
    era: pkgInfo: callPackage (import (lib.path.append ./. ("build-" + era + ".nix")) pkgInfo) { };
in
{
  "5.0" =
    (makeDocBookVersion "xml-rng" rec {
      version = "5.0.1";
      url = "https://docbook.org/xml/${version}/docbook-${version}.zip";
      hash = "sha256-evnfRSQQ4DWjcHiD5DA5tAYvCdwvSfLphto+TAOG48c=";
    }).overrideAttrs
      (previousAttrs: {
        installPhase = ''
          runHook preInstall

          dst_xml=$out/share/xml/docbook-5.0
          dst_doc=$out/share/doc/docbook-5.0
          mkdir -p $dst_xml $dst_doc

          # The source dir must be specified manually, because sourceRoot is set to ".".
          cp -pr -t $dst_xml docbook-${previousAttrs.version}/*
          mv -t $dst_doc $dst_xml/docs/*
          rm -rf $dst_xml/ChangeLog

          # Backwards compatibility. Will remove eventually.
          mkdir -p $out/xml/rng $out/xml/dtd
          ln -s $dst_xml/rng $out/xml/rng/docbook
          ln -s $dst_xml/dtd $out/xml/dtd/docbook

          runHook postInstall
        '';

        fixupPhase = ''
          runHook preFixup

          substituteInPlace $dst_xml/catalog.xml \
              --replace-fail uri=\" uri=\"$dst_xml/

          runHook postFixup
        '';
      });
  "4.5" = makeDocBookVersion "xml-dtd" {
    version = "4.5";
    hash = "sha256-Tk4DeiuDyYxslIGDkNS90/bhD27GLdeRiFlOJhkNx7Q=";
  };
  "4.4" = makeDocBookVersion "xml-dtd" {
    version = "4.4";
    hash = "sha256-AvFZ64jEJU2V6DHFHBRLGGOyFtkJtf9FdDoc5vUnMJA=";
  };
  "4.3" = makeDocBookVersion "xml-dtd" {
    version = "4.3";
    hash = "sha256-IwaKlOpv1ISwBMWnPsNqZqpH6o8Na2LMFpWTH1wUNGQ=";
  };
  "4.2" = makeDocBookVersion "xml-dtd" {
    version = "4.2";
    hash = "sha256-rMRgHk+XoZYHa35ks2jZJIsHx6vyazSgLMpA7uvmD6I=";
  };
  "4.1.2" =
    (makeDocBookVersion "xml-dtd" {
      version = "4.1.2";
      url = "https://docbook.org/xml/4.1.2/docbkx412.zip";
      hash = "sha256-MPBkQGTg6nF1FDglGUCxQx9GrK2oFKBihw9IbHcud3I=";
    }).overrideAttrs
      {
        postPatch =
          let
            docbook42catalog = fetchurl {
              url = "https://docbook.org/xml/4.2/catalog.xml";
              sha256 = "sha256-J0g0JhEzZpuYlm0qU+lKmLc1oUbD5FKQHuUAKrC5kKI=";
            };
          in
          ''
            cp ${docbook42catalog} catalog.xml
            substituteInPlace catalog.xml \
                --replace-fail V4.2 V4.1.2
          '';
      };
}
