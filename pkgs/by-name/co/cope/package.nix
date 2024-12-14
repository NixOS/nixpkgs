{
  lib,
  fetchFromGitHub,
  perl,
  perlPackages,
}:

perlPackages.buildPerlPackage {
  pname = "cope";
  version = "0-unstable-2024-03-27";

  src = fetchFromGitHub {
    owner = "deftdawg";
    repo = "cope";
    rev = "ad0c1ebec5684f5ec3e8becf348414292c489175";
    hash = "sha256-LMAir7tUkjHtKz+KME/Raa9QHGN1g0bzr56fNxfURQY=";
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
    mkdir -p $out/bin
    mv $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto/share/dist/Cope/* $out/bin/
    rm -r $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto
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
