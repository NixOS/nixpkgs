{
  requireFile,
  runCommand,

  region ? "us",
  showRegionMessage ? true,
}:
# nixpkgs assumes that a file derivation is a setup script and tries to load it, so we have to put this in a directory
let
  file = requireFile {
    name = "baserom.${region}.z64";
    message = ''
      This nix expression requires that baserom.${region}.z64 is
      already part of the store. To get this file you can dump your Super Mario 64 cartridge's contents
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
      ${
        if showRegionMessage then
          ''Note that if you are not using a US baserom, you must overwrite the "region" attribute with either "eu" or "jp".''
        else
          ""
      }
    '';
    sha256 =
      {
        "us" = "17ce077343c6133f8c9f2d6d6d9a4ab62c8cd2aa57c40aea1f490b4c8bb21d91";
        "eu" = "c792e5ebcba34c8d98c0c44cf29747c8ee67e7b907fcc77887f9ff2523f80572";
        "jp" = "9cf7a80db321b07a8d461fe536c02c87b7412433953891cdec9191bfad2db317";
      }
      .${region};
  };
  result = runCommand "baserom-${region}-safety-dir" { } ''
    mkdir $out
    ln -s ${file} $out/${file.name}
  '';
in
result
// {
  romPath = "${result.outPath}/${file.name}";
}
