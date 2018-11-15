{ stdenv, python3 }:

let
  pythonPackages = python3.pkgs;
in
with stdenv.lib;
pythonPackages.buildPythonApplication rec {
  pname = "spruned";
  version = "0.0.4b4";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "b156ad410ae71651aafb4ffc639ad491614622a53b3cb8211fd49e2579642f18";
  };

  disabled = ! pythonPackages.pythonAtLeast "3.5";

  propagatedBuildInputs =
    with pythonPackages; [
      async-timeout
      jsonrpcserver
      sqlalchemy
      plyvel
      daemonize
      aiohttp
      pycoin
    ];

  patchPhase = ''
    sed -i 's,import spruned,,;s,spruned.__version__,"${version}",' setup.py

    substituteInPlace spruned/application/tools.py \
      --replace "subprocess.call(['ping" "subprocess.call(['/run/wrappers/bin/ping"

    substituteInPlace requirements.txt \
      --replace 'sqlalchemy==1.2.6' 'sqlalchemy==1.2.*' \
      --replace 'aiohttp==3.0.0b0' aiohttp \
      --replace 'daemonize==2.4.7' daemonize \
      --replace 'async-timeout==2.0.1' async-timeout \
      --replace 'jsonrpcserver==3.5.3' jsonrpcserver \
      --replace 'plyvel==0.9.0' plyvel
  '';

  doCheck = false;

  meta = {
    description = "A Bitcoin lightweight pseudonode with RPC that can fetch any block or transaction";
    homepage = https://github.com/gdassori/spruned;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
