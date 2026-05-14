{
  stdenv,
  lib,
  fetchFromGitHub,
  parted,
  systemd,
  argp-standalone,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "f3";
  version = "9.0";

  src = fetchFromGitHub {
    owner = "AltraMayor";
    repo = "f3";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZajlFGXJcYUVe/wUFfdPYVW8stOo1Aqe8uD2Bm9KIk0=";
  };

  postPatch = ''
    sed -i 's/-oroot -groot//' Makefile

    for f in f3write.h2w log-f3wr; do
     substituteInPlace $f \
       --replace '$(dirname $0)' $out/bin
    done
  '';

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      systemd
      parted
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ argp-standalone ];

  buildFlags = [
    "all" # f3read, f3write
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "extra"; # f3brew, f3fix, f3probe

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  installTargets = [
    "install"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "install-extra";

  postInstall = ''
    install -Dm555 -t $out/bin f3write.h2w log-f3wr
    install -Dm444 -t $out/share/doc/f3 LICENSE README.rst
  '';

  meta = {
    description = "Fight Flash Fraud";
    homepage = "https://fight-flash-fraud.readthedocs.io/en/stable/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      makefu
    ];
  };
})
