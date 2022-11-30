{ lib
, flutter
, python3
, fetchFromGitHub
, stdenv
, pcre2
}:

let
  vendorHashes = {
    x86_64-linux = "sha256-BwhWA8N0S55XkljDKPNkDhsj0QSpmJJ5MwEnrPjymS8=";
    aarch64-linux = "sha256-T1aGz3+2Sls+rkUVDUo39Ky2igg+dxGSUaf3qpV7ovQ=";
  };

  version = "6.0.2";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubioath-flutter";
    rev = version;
    sha256 = "13nh5qpq02c6azfdh4cbzhlrq0hs9is45q5z5cnxg84hrx26hd4k";
  };
  meta = with lib; {
    description = "Yubico Authenticator for Desktop";
    homepage = "https://github.com/Yubico/yubioath-flutter";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = builtins.attrNames vendorHashes;
  };

  helper = python3.pkgs.callPackage ./helper.nix { inherit src version meta; };
in
flutter.mkFlutterApp rec {
  pname = "yubioath-flutter";
  inherit src version meta;

  passthru.helper = helper;

  vendorHash = vendorHashes."${stdenv.system}";

  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
      --replace "../build/linux/helper" "${helper}/libexec/helper"
  '';

  preInstall = ''
    # Make sure we have permission to delete things CMake has copied in to our build directory from elsewhere.
    chmod -R +w build/
  '';
  postInstall = ''
    # Swap the authenticator-helper symlink with the correct symlink.
    ln -fs "${helper}/bin/authenticator-helper" "$out/app/helper/authenticator-helper"
  '';

  buildInputs = [
    pcre2
  ];
}
