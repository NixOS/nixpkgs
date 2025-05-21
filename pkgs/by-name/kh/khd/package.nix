{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "khd";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "khd";
    rev = "v${version}";
    sha256 = "0nzfhknv1s71870w2dk9dy56a3g5zsbjphmfrz0vsvi438g099r4";
  };

  patches = [
    # Fixes build issues, remove with >3.0.0
    (fetchpatch {
      url = "https://github.com/koekeishiya/khd/commit/4765ae0b4c7d4ca56319dc92ff54393cd9e03fbc.patch";
      sha256 = "0kvf5hxi5bf6pf125qib7wn7hys0ag66zzpp4srj1qa87lxyf7np";
    })
  ];

  buildPhase = ''
    make install
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/khd $out/bin/khd

    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.khd.plist} $out/Library/LaunchDaemons/org.nixos.khd.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.khd.plist --subst-var out
  '';

  meta = with lib; {
    description = "Simple modal hotkey daemon for OSX";
    homepage = "https://github.com/koekeishiya/khd";
    downloadPage = "https://github.com/koekeishiya/khd/releases";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lnl7 ];
    license = licenses.mit;
  };
}
