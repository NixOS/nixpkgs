{
  stdenv,
  coreutils,
  fetchFromCodeberg,
  git,
  lib,
  makeWrapper,
  net-tools,
  perl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitolite";
  version = "3.6.14";

  src = fetchFromCodeberg {
    owner = "sitaramc";
    repo = "gitolite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BwpqvjpHzoypV91W/QReAgiNrmpxZ0IE3W/bpCVO1GE=";
  };

  buildInputs = [
    net-tools
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
      --replace hostname "${net-tools}/bin/hostname"
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
    echo ${finalAttrs.version} > $out/bin/VERSION
  '';

  passthru.tests = {
    gitolite = nixosTests.gitolite;
  };

  meta = {
    description = "Finely-grained git repository hosting";
    homepage = "https://gitolite.com/gitolite/index.html";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.thoughtpolice
      lib.maintainers.lassulus
      lib.maintainers.tomberek
    ];
  };
})
