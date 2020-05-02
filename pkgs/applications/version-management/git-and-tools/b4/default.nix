{ stdenv, buildPythonApplication, fetchgit, lib, isPy27,
requests }:

buildPythonApplication rec {
  pname = "b4";
  version = "0.4.0";
  disabled = isPy27;

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/b4/b4.git";
    sha256 = "022i4abpp2q79pn5lg9gi4zy51m18mm4q7f4w36dkfvyd6n60dfm";
  };

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "A tool to work with public-inbox and patch archives";
    longDescription = ''
      This is a helper utility to work with patches made available via a
      public-inbox archive like lore.kernel.org. It is written to make it
      easier to participate in a patch-based workflows, like those used in
      the Linux kernel development.

      The name "b4" was chosen for ease of typing and because B-4 was the
      precursor to Lore and Data in the Star Trek universe.
    '';
    homepage = "https://git.kernel.org/pub/scm/utils/b4/b4.git/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

