{ stdenv, fetchFromGitLab, cmake, vtk_9, libX11, libGL, Cocoa, OpenGL }:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "1.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "f3d";
    repo = "f3d";
    rev = "v${version}";
    sha256 = "0a6r0jspkhl735f6zmnhby1g4dlmjqd5izgsp5yfdcdhqj4j63mg";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ vtk_9 ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libGL libX11 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa OpenGL ];

  meta = with stdenv.lib; {
    description = "Fast and minimalist 3D viewer using VTK";
    homepage = "https://kitware.github.io/F3D";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    platforms = with platforms; unix;
  };
}
