{
  lib,
  fetchFromGitHub,
  pandoc,
  stdenv,
  nixosTests,
  fetchpatch,
  # The man page requires pandoc to build and resides in a separate "man"
  # output which is pulled in on-demand. There is no need to disabled it unless
  # pandoc is hard to build on your platform.
  withManpage ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "earlyoom";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HZ7llMNdx2u1a6loIFjXt5QNkYpJp8GqLKxDf9exuzE=";
  };

  outputs = [ "out" ] ++ lib.optionals withManpage [ "man" ];

  patches = [
    ./0000-fix-dbus-path.patch
    # Respect `MANDIR`.
    (fetchpatch {
      url = "https://github.com/rfjakob/earlyoom/commit/c5a1799a5ff4b3fd3132d50a510e8c126933cf4a.patch";
      hash = "sha256-64AkpTMmjiqZ6Byq6687zNIqrQ/IGRGgzzjyyAfcg14=";
    })
    # Correctly handle `PREFIX` as a default rather than always-concatenate.
    (fetchpatch {
      url = "https://github.com/rfjakob/earlyoom/commit/f7d6f1cc925962fbdcf57b1c2aeeabbf11e2d542.patch";
      hash = "sha256-DJDeQzcEGJMoMGIi1D/ogMaKG1VQvPZN9jXtUDGjyjk=";
    })
  ];

  nativeBuildInputs = lib.optionals withManpage [ pandoc ];

  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optional withManpage "MANDIR=${placeholder "man"}/share/man";

  passthru.tests = {
    inherit (nixosTests) earlyoom;
  };

  meta = {
    homepage = "https://github.com/rfjakob/earlyoom";
    description = "Early OOM Daemon for Linux";
    longDescription = ''
      earlyoom checks the amount of available memory and free swap up to 10
      times a second (less often if there is a lot of free memory). By default
      if both are below 10%, it will kill the largest process (highest
      oom_score). The percentage value is configurable via command line
      arguments.
    '';
    license = lib.licenses.mit;
    mainProgram = "earlyoom";
    maintainers = with lib.maintainers; [
      oxalica
    ];
    platforms = lib.platforms.linux;
  };
})
