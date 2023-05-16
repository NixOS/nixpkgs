<<<<<<< HEAD
{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonApplication rec {
  pname = "luigi";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zIZC3rbiLwYB7o34rT3mOagVIbfmY6elBEkZGFrSs1c=";
  };

  propagatedBuildInputs = with python3.pkgs; [ python-dateutil tornado python-daemon boto3 tenacity ];
=======
{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "luigi";
  version = "3.0.2";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "b4b1ccf086586d041d7e91e68515d495c550f30e4d179d63863fea9ccdbb78eb";
  };

  propagatedBuildInputs = with python3.pkgs; [ python-dateutil tornado python-daemon boto3 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Requires tox, hadoop, and google cloud
  doCheck = false;

  # This enables accessing modules stored in cwd
<<<<<<< HEAD
  makeWrapperArgs = [ "--prefix PYTHONPATH . :" ];
=======
  makeWrapperArgs = ["--prefix PYTHONPATH . :"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python package that helps you build complex pipelines of batch jobs";
    longDescription = ''
      Luigi handles dependency resolution, workflow management, visualization,
      handling failures, command line integration, and much more.
    '';
    homepage = "https://github.com/spotify/luigi";
    changelog = "https://github.com/spotify/luigi/releases/tag/${version}";
<<<<<<< HEAD
    license = [ licenses.asl20 ];
=======
    license =  [ licenses.asl20 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.bhipple ];
  };
}
