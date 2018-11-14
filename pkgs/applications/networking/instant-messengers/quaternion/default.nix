{ stdenv, lib, fetchFromGitHub, fetchpatch, qtbase, qtquickcontrols, cmake, libqmatrixclient }:

stdenv.mkDerivation rec {
  name = "quaternion-${version}";
  version = "0.0.9.2";

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "Quaternion";
    rev    = "v${version}";
    sha256 = "0zrr4khbbdf5ziq65gi0cb1yb1d0y5rv18wld22w1x96f7fkmrib";
  };

  buildInputs = [ qtbase qtquickcontrols ];

  nativeBuildInputs = [ cmake ];

  patches = [
    # https://github.com/QMatrixClient/Quaternion/pull/400
    (fetchpatch {
      url = "https://github.com/QMatrixClient/Quaternion/commit/6cb29834efc343dc2bcf1db62cfad2dc4c121c54.patch";
      sha256 = "0n7mgzzrvx9sa657rfb99i0mjh1k0sn5br344mknqy3wgqdr7s3x";
    })
  ];

  # libqmatrixclient is now compiled as a dynamic library but quarternion cannot use it yet
  # https://github.com/QMatrixClient/Quaternion/issues/239
  postPatch = ''
    rm -rf lib
    ln -s ${libqmatrixclient.src} lib
  '';

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
}
