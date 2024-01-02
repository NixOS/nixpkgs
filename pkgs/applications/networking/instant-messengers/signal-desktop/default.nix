{ callPackage, stdenv }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = rec {
    dir = "Signal";
    version = "6.40.0";
    version-aarch64 = "6.40.0";
    url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop/signal-desktop_${version}_amd64.deb";
    url-aarch64 = "https://github.com/0mniteck/Signal-Desktop-Mobian/raw/${version-aarch64}/builds/release/signal-desktop_${version-aarch64}_arm64.deb";
    hash = "sha256-vyXHlycPSyEyv938IKzGM6pdERHHerx2CLY/U+WMrH4=";
    hash-aarch64 = "sha256-3Pi0c+CGcJR1M4ll51m+B5PmGIcIjjlc0qa9b8rkMeU=";
  };
  signal-desktop-beta = rec {
    dir = "Signal Beta";
    version = "6.40.0-beta.2";
    hash = "sha256-pfedkxbZ25DFgz+/N7ZEb9LwKrHuoMM+Zi+Tc21QPsg=";
    url = "https://updates.signal.org/desktop/apt/pool/s/signal-desktop-beta/signal-desktop-beta_${version}_amd64.deb";
  };
}
