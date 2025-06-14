{
  lib,
  fetchFromGitHub,
  perl,
  perlPackages,
}:

perlPackages.buildPerlPackage {
  pname = "cope";
  version = "0-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "deftdawg";
    repo = "cope";
    rev = "4275d3a2d788591124d237717cf8c1b0f4ba5293";
    hash = "sha256-MEMh6QJ1hNJFdEtyjyrehkY3CKEOrHs7msk17T35MMg=";
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
    mkdir -p $out/bin $out/libexec
    mv $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto/share/dist/Cope/* $out/libexec/
    rm -r $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto
    # replace cope with a new cope
    cp $src/new-cope $out/bin/cope
    cp -f $src/new-cope $out/libexec/cope
  '';

  meta = {
    description = "Colourful wrapper for terminal programs";
    homepage = "https://github.com/deftdawg/cope";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    maintainers = with lib.maintainers; [ deftdawg ];
  };
}
