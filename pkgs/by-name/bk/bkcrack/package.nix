{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bkcrack";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "kimci86";
    repo = "bkcrack";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MFY+YBw9cpmUHrL7fpop63ty0ZdESlAgrWRYwK0IowY=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBKCRACK_BUILD_TESTING=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
  ];

  postInstall = ''
    mkdir -p $out/bin $out/share/doc/bkcrack $out/share/licenses/bkcrack
    mv $out/bkcrack $out/bin/
    mv $out/license.txt $out/share/licenses/bkcrack
    mv $out/example $out/tools $out/readme.md $out/share/doc/bkcrack
  '';

  doCheck = true;

  meta = with lib; {
    description = "Crack legacy zip encryption with Biham and Kocher's known plaintext attack";
    homepage = "https://github.com/kimci86/bkcrack";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ erdnaxe ];
    mainProgram = "bkcrack";
  };
})
