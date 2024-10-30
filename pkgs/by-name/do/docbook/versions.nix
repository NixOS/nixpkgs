{
  lib,
  callPackage,
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
}
