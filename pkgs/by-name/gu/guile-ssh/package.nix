{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  guile,
  libssh,
  autoreconfHook,
  pkg-config,
  texinfo,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-ssh";
  # XXX: using unstable to ensure proper build with libssh 0.11.1 (https://github.com/artyom-poptsov/guile-ssh/issues/42)
  version = "0.17.0-unstable-2024-10-15";

  src = fetchFromGitHub {
    owner = "artyom-poptsov";
    repo = "guile-ssh";
    rev = "9336580f92f83bb73041c5374b400144a56b4c35";
    hash = "sha256-Hwg0xaNSm/SEZfzczjb7o8TJXfzT1mmOk1rJROxahLQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/artyom-poptsov/guile-ssh/pull/31/commits/38636c978f257d5228cd065837becabf5da16854.patch";
      hash = "sha256-J+TDgdjihKoEjhbeH+BzqrHhjpVlGdscRj3L/GAFgKg=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
    which
  ];

  buildInputs = [
    guile
  ];

  propagatedBuildInputs = [
    libssh
  ];

  enableParallelBuilding = true;

  # FAIL: server-client.scm
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = ''
    mv $out/bin/*.scm $out/share/guile-ssh
    rmdir $out/bin
  '';

  meta = with lib; {
    description = "Bindings to Libssh for GNU Guile";
    homepage = "https://github.com/artyom-poptsov/guile-ssh";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      ethancedwards8
      foo-dogsquared
    ];
    platforms = guile.meta.platforms;
  };
})
