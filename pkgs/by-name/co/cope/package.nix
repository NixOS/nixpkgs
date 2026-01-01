{
  lib,
  fetchFromGitHub,
<<<<<<< HEAD
  perlPackages,
  makeWrapper,
}:
perlPackages.buildPerlPackage {
  pname = "cope";
  version = "0-unstable-2025-06-20";
=======
  perl,
  perlPackages,
}:

perlPackages.buildPerlPackage {
  pname = "cope";
  version = "0-unstable-2024-03-27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "deftdawg";
    repo = "cope";
<<<<<<< HEAD
    rev = "6d0322a8493361ad32e454b97998df715dbe7b97";
    hash = "sha256-VQveV7avM/4nbLroyujJaSoVAP3pXhwrzqzI3eMzxVo=";
  };
  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [
    EnvPath
    ExporterTiny
=======
    rev = "ad0c1ebec5684f5ec3e8becf348414292c489175";
    hash = "sha256-LMAir7tUkjHtKz+KME/Raa9QHGN1g0bzr56fNxfURQY=";
  };

  buildInputs = with perlPackages; [
    EnvPath
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    FileShareDir
    IOTty
    IOStty
    ListMoreUtils
    RegexpCommon
    RegexpIPv6
  ];

<<<<<<< HEAD
  postInstall =
    let
      perlDeps = with perlPackages; [
        EnvPath
        ExporterTiny
        FileShareDir
        IOTty
        IOStty
        ListMoreUtils
        RegexpCommon
        RegexpIPv6
      ];
      perlPath = perlPackages.makePerlPath perlDeps;
    in
    ''
      mkdir -p $out/bin # $out/libexec
      mv $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto/share/dist/Cope $out/libexec
      # Wrap all Perl scripts in the Cope directory before moving them
      for script in $out/libexec/*; do
        if [[ -f "$script" && -x "$script" ]]; then
          wrapProgram "$script" \
            --set PERL5LIB "${perlPath}:$out/lib/perl5/site_perl"
          sed -i "1s|^#!.*perl|#!${perlPackages.perl}/bin/perl|" "$out/libexec/.''${script##*/}-wrapped"
        fi
      done
      rm -r $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto

      # replace cope with a new cope, new-cope is a bash script which doesn't need to be wrapped
      cp $src/new-cope $out/bin/cope
      cp -f $src/new-cope $out/libexec/cope
    '';
=======
  postInstall = ''
    mkdir -p $out/bin
    mv $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto/share/dist/Cope/* $out/bin/
    rm -r $out/${perlPackages.perl.libPrefix}/${perlPackages.perl.version}/auto
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Colourful wrapper for terminal programs";
    homepage = "https://github.com/deftdawg/cope";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    maintainers = with lib.maintainers; [ deftdawg ];
<<<<<<< HEAD
    broken = true; # requires old Perl we don't ship anymore
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
