{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  # "dlsym" for OSX version < 12
  darwinHookMethod ? "dyld",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proxychains-ng";
  version = "4.17";

  src = fetchFromGitHub {
    owner = "rofl0r";
    repo = "proxychains-ng";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-cHRWPQm6aXsror0z+S2Ddm7w14c1OvEruDublWsvnXs=";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/issues/136093
    ./swap-priority-4-and-5-in-get_config_path.patch
    # The fix is not present in v4.17; remove the patch next version update.
    # https://github.com/rofl0r/proxychains-ng/issues/557
    (fetchpatch {
      url = "https://github.com/rofl0r/proxychains-ng/commit/fffd2532ad34bdf7bf430b128e4c68d1164833c6.patch";
      hash = "sha256-l3qSFUDMUfVDW1Iw+R2aW/wRz4CxvpR4eOwx9KzuAAo=";
    })
    (fetchpatch {
      name = "CVE-2025-34451.patch";
      url = "https://github.com/httpsgithu/proxychains-ng/commit/cc005b7132811c9149e77b5e33cff359fc95512e.patch";
      hash = "sha256-taCNTm3qvBmLSSO0DEBu15tDZ35PDzHGtbZW7nLrRDw=";
    })
  ];

  configureFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--hookmethod=${darwinHookMethod}"
  ];

  installFlags = [
    "install-config"
    "install-zsh-completion"
  ];

  meta = {
    description = "Preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies";
    homepage = "https://github.com/rofl0r/proxychains-ng";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      zenithal
      usertam
    ];
    platforms = lib.platforms.unix;
    mainProgram = "proxychains4";
  };
})
