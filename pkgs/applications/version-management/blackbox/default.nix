{
  lib,
  stdenv,
  fetchFromGitHub,
  expect,
  which,
  gnupg,
  coreutils,
  git,
  pinentry,
  gnutar,
  procps,
}:

stdenv.mkDerivation rec {
  pname = "blackbox";
  version = "1.20220610";

  src = fetchFromGitHub {
    owner = "stackexchange";
    repo = "blackbox";
    rev = "v${version}";
    hash = "sha256-g0oNV7Nj7ZMmsVQFVTDwbKtF4a/Fb3WDB+NRx9IGSWA=";
  };

  buildInputs = [ gnupg ];

  # https://github.com/NixOS/nixpkgs/issues/134445
  doCheck = !stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;

  nativeCheckInputs = [
    expect
    which
    coreutils
    pinentry
    git
    gnutar
    procps
  ];

  postPatch = ''
    patchShebangs bin tools
    substituteInPlace Makefile \
      --replace "PREFIX?=/usr/local" "PREFIX=$out"

    substituteInPlace tools/confidence_test.sh \
      --replace 'PATH="''${blackbox_home}:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/local/bin:/usr/pkg/bin:/usr/pkg/gnu/bin:/usr/local/MacGPG2/bin:/opt/homebrew/bin:''${blackbox_home}"' \
        "PATH=/build/source/bin/:$PATH"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    make copy-install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Safely store secrets in a VCS repo";
    homepage = "https://github.com/StackExchange/blackbox";
    maintainers = [ ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
