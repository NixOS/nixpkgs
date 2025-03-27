{
  stdenv,
  coreutils,
  fetchFromGitHub,
  git,
  lib,
  makeWrapper,
  nettools,
  perl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "gitolite";
  version = "3.6.13";

  src = fetchFromGitHub {
    owner = "sitaramc";
    repo = "gitolite";
    rev = "v${version}";
    hash = "sha256-/VBu+aepIrxWc2padPa/WoXbIdKfIwqmA/M8d1GE5FI=";
  };

  buildInputs = [
    nettools
    perl
  ];
  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ git ];

  dontBuild = true;

  postPatch = ''
    substituteInPlace ./install --replace " 2>/dev/null" ""
    substituteInPlace src/lib/Gitolite/Hooks/PostUpdate.pm \
      --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace src/lib/Gitolite/Hooks/Update.pm \
      --replace /usr/bin/perl "${perl}/bin/perl"
    substituteInPlace src/lib/Gitolite/Setup.pm \
      --replace hostname "${nettools}/bin/hostname"
    substituteInPlace src/commands/sskm \
      --replace /bin/rm "${coreutils}/bin/rm"
  '';

  postFixup = ''
    wrapProgram $out/bin/gitolite-shell \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          (perl.withPackages (p: [ p.JSON ]))
        ]
      }
  '';

  installPhase = ''
    mkdir -p $out/bin
    perl ./install -to $out/bin
    echo ${version} > $out/bin/VERSION
  '';

  passthru.tests = {
    gitolite = nixosTests.gitolite;
  };

  meta = with lib; {
    description = "Finely-grained git repository hosting";
    homepage = "https://gitolite.com/gitolite/index.html";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [
      maintainers.thoughtpolice
      maintainers.lassulus
      maintainers.tomberek
    ];
  };
}
