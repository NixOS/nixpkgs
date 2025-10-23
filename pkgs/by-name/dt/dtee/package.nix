{
  fetchFromGitHub,
  lib,
  nix-update-script,
  pkgs,
  stdenv,
  # nativeBuildInputs
  gettext,
  meson,
  ninja,
  pkg-config,
  python3,
  sphinx,
  # buildInputs
  boost,
  # nativeCheckInputs
  bash,
  coreutils,
  diffutils,
  findutils,
  glibcLocales,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtee";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "nomis";
    repo = "dtee";
    tag = finalAttrs.version;
    hash = "sha256-trREhITO3cY4j75mpudWhOA3GXI0Q8GkUxNq2s6154w=";
  };

  passthru.updateScript = nix-update-script { };

  # Make "#!/usr/bin/env bash" work in tests
  postPatch = "patchShebangs tests";

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    sphinx # For the man page
  ];

  buildInputs = [ boost ];

  nativeCheckInputs = [
    bash
    coreutils
    diffutils
    findutils
    glibcLocales # For tests that check translations work
  ];

  # Use the correct copyright year on the man page (workaround for https://github.com/sphinx-doc/sphinx/issues/13231)
  preBuild = ''
    SOURCE_DATE_EPOCH=$(python3 $NIX_BUILD_TOP/$sourceRoot/release_date.py -e ${finalAttrs.version}) || exit 1
    export SOURCE_DATE_EPOCH
  '';

  mesonFlags = [ "--unity on" ];
  doCheck = true;

  meta = {
    description = "Run a program with standard output and standard error copied to files";
    longDescription = ''
      Run a program with standard output and standard error copied to files
      while maintaining the original standard output and standard error in
      the original order. When invoked as "cronty", allows programs to be run
      from cron, suppressing all output unless the process outputs an error
      message or has a non-zero exit status whereupon the original output
      will be written as normal and the exit code will be appended to standard
      error.
    '';

    homepage = "https://dtee.readthedocs.io/";
    downloadPage = "https://github.com/nomis/dtee/releases/tag/${finalAttrs.version}";
    changelog = "https://dtee.readthedocs.io/en/${finalAttrs.version}/changelog.html";

    license = lib.licenses.gpl3Plus;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = with lib.maintainers; [ nomis ];
    mainProgram = "dtee";
    # Only Linux has reliable local datagram sockets
    platforms = lib.platforms.linux;
  };
})
