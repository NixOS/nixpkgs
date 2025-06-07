{
  lib,
  fetchFromGitHub,
  perl,
  perlPackages,
}:

perlPackages.buildPerlPackage {
  pname = "cope";
  version = "0-unstable-2025-06-07";

  src = fetchFromGitHub {
    owner = "deftdawg";
    repo = "cope";
    rev = "4846a098ca147482b8de1a4cb4625b1479a55346";
    hash = "sha256-sQ6HfCO4H3udpsR0IMv5lGwr947k82zoHJjet7qr6Uo=";
  };

  buildInputs = with perlPackages; [
    EnvPath
    FileShareDir
    IOPty
    IOStty
    ListMoreUtils
    RegexpCommon
    RegexpIPv6
  ];
  postInstall = ''
    mkdir -p $out/bin $out/bin/bin-cope
    mv $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto/share/dist/Cope/* $out/bin/bin-cope/
    rm -r $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto
    # replace cope with a new cope
    cp $src/new-cope $out/bin/cope
    cp -f $src/new-cope $out/bin/bin-cope/cope
  '';

  meta = {
    description = "A colourful wrapper for terminal programs";
    homepage = "https://github.com/deftdawg/cope";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    maintainers = with lib.maintainers; [ deftdawg ];
  };
}
