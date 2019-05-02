{ stdenv, lib, fetchFromGitHub, cmake
, qtbase, qtquickcontrols, qtkeychain, qtmultimedia, qttools
, libqmatrixclient_0_4, libqmatrixclient_0_5 }:

let
  generic = version: sha256: prefix: library: stdenv.mkDerivation rec {
    name = "quaternion-${version}";

    src = fetchFromGitHub {
      owner = "QMatrixClient";
      repo  = "Quaternion";
      rev   = "${prefix}${version}";
      inherit sha256;
    };

    buildInputs = [ qtbase qtmultimedia qtquickcontrols qtkeychain qttools library ];

    nativeBuildInputs = [ cmake ];

    postInstall = if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      mv $out/bin/quaternion.app $out/Applications
      rmdir $out/bin || :
    '' else ''
      substituteInPlace $out/share/applications/quaternion.desktop \
        --replace 'Exec=quaternion' "Exec=$out/bin/quaternion"
    '';

    meta = with lib; {
      description = "Cross-platform desktop IM client for the Matrix protocol";
      homepage    = https://matrix.org/docs/projects/client/quaternion.html;
      license     = licenses.gpl3;
      maintainers = with maintainers; [ peterhoeg ];
      inherit (qtbase.meta) platforms;
      inherit version;
    };
  };

in rec {
  quaternion     = generic "0.0.9.4"     "12mkwiqqbi4774kwl7gha72jyf0jf547acy6rw8ry249zl4lja54" "" libqmatrixclient_0_5;
  quaternion-git = quaternion;
}
