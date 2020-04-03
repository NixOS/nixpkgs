{ mkDerivation, stdenv, lib, fetchFromGitHub, cmake
, qtbase, qtquickcontrols, qtkeychain, qtmultimedia, qttools
, libqmatrixclient_0_5
, libsecret
}:

let
  generic = version: sha256: prefix: library: mkDerivation {
    pname = "quaternion";
    inherit version;

    src = fetchFromGitHub {
      owner = "QMatrixClient";
      repo  = "Quaternion";
      rev   = "${prefix}${version}";
      inherit sha256;
    };

    buildInputs = [ qtbase qtmultimedia qtquickcontrols qtkeychain library libsecret ];

    nativeBuildInputs = [ cmake qttools ];

    postInstall = if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      mv $out/bin/quaternion.app $out/Applications
      rmdir $out/bin || :
    '' else ''
      substituteInPlace $out/share/applications/com.github.quaternion.desktop \
        --replace 'Exec=quaternion' "Exec=$out/bin/quaternion"
    '';

    meta = with lib; {
      description = "Cross-platform desktop IM client for the Matrix protocol";
      homepage    = "https://matrix.org/docs/projects/client/quaternion.html";
      license     = licenses.gpl3;
      maintainers = with maintainers; [ peterhoeg ];
      inherit (qtbase.meta) platforms;
      inherit version;
    };
  };

in rec {
  quaternion     = generic "0.0.9.4e"     "0hqhg7l6wpkdbzrdjvrbqymmahziri07ba0hvbii7dd2p0h248fv" "" libqmatrixclient_0_5;

  quaternion-git = quaternion;
}
