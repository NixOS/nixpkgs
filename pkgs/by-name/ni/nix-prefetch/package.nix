{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  asciidoc,
  docbook_xml_dtd_45,
  docbook_xsl,
  installShellFiles,
  libxml2,
  libxslt,
  makeWrapper,

  # wrapper
  coreutils,
  gawk,
  gitMinimal,
  gnugrep,
  gnused,
  jq,
  nix,

  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nix-prefetch";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "msteen";
    repo = "nix-prefetch";
    tag = finalAttrs.version;
    hash = "sha256-6UOxRz/2Rhjl/9nyGJrl3fjl6Fkwc38HONi/UEw3my8=";
    # the stat call has to be in a subshell or we get the current date
    postFetch = ''
      echo $(stat -c %Y $out) > $out/.timestamp
    '';
  };

  patches = [
    (fetchpatch {
      name = "fix-prefetching-hash-key.patch";
      url = "https://github.com/msteen/nix-prefetch/commit/508237f48f7e2d8496ce54f38abbe57f44d0cbca.patch";
      hash = "sha256-9SYPcRFZaVyNjMUVdXbef5eGvLp/kr379eU9lG5GgE0=";
    })
  ];

  postPatch = ''
    lib=$out/lib/nix-prefetch

    substituteInPlace doc/nix-prefetch.1.asciidoc \
      --subst-var-by version $version

    substituteInPlace src/main.sh \
      --subst-var-by lib $lib \
      --subst-var-by version $version

    substituteInPlace src/tests.sh \
      --subst-var-by bin $out/bin
  '';

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    installShellFiles
    libxml2
    libxslt
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    a2x -a revdate=$(date --utc --date=@$(cat $src/.timestamp) +%d/%m/%Y) \
      -f manpage doc/nix-prefetch.1.asciidoc
  '';

  installPhase = ''
    install -Dm555 -t $lib src/*.sh
    install -Dm444 -t $lib lib/*
    makeWrapper $lib/main.sh $out/bin/nix-prefetch \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gitMinimal
          gnugrep
          gnused
          jq
          nix
        ]
      }

    installManPage doc/nix-prefetch.?

    installShellCompletion --name nix-prefetch contrib/nix-prefetch-completion.{bash,zsh}

    mkdir -p $out/share/doc/nix-prefetch/contrib
    cp -r contrib/hello_rs $out/share/doc/nix-prefetch/contrib
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Prefetch any fetcher function call, e.g. package sources";
    homepage = "https://github.com/msteen/nix-prefetch";
    changelog = "https://github.com/msteen/nix-prefetch/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ msteen ];
    platforms = lib.platforms.all;
    mainProgram = "nix-prefetch";
  };
})
