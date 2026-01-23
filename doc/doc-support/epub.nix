# To build this derivation, run `nix-build -A nixpkgs-manual.epub`
{
  lib,
  runCommand,
  docbook_xsl_ns,
  libxslt,
  zip,
}:
runCommand "manual.epub"
  {
    nativeBuildInputs = [
      libxslt
      zip
    ];

    epub = ''
      <book xmlns="http://docbook.org/ns/docbook"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            version="5.0"
            xml:id="nixpkgs-manual">
        <info>
          <title>Nixpkgs Manual</title>
          <subtitle>Version ${lib.version}</subtitle>
        </info>
        <chapter>
          <title>Temporarily unavailable</title>
          <para>
            The Nixpkgs manual is currently not available in EPUB format,
            please use the <link xlink:href="https://nixos.org/nixpkgs/manual">HTML manual</link>
            instead.
          </para>
          <para>
            If you've used the EPUB manual in the past and it has been useful to you, please
            <link xlink:href="https://github.com/NixOS/nixpkgs/issues/237234">let us know</link>.
          </para>
        </chapter>
      </book>
    '';

    passAsFile = [ "epub" ];
  }
  ''
    mkdir scratch
    xsltproc \
      --param chapter.autolabel 0 \
      --nonet \
      --output scratch/ \
      ${docbook_xsl_ns}/xml/xsl/docbook/epub/docbook.xsl \
      $epubPath

    echo "application/epub+zip" > mimetype
    zip -0Xq -b "$TMPDIR" "$out" mimetype
    cd scratch && zip -Xr9D -b "$TMPDIR" "$out" *
  ''
