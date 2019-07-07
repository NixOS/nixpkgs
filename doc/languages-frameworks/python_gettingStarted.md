1. Global installation of Python in `configuration.nix` in `environment.systemPackages` with e.g. `(python36.withPackages(ps: with ps; [ numpy ]))` here i chose python 3.6 any ohter version should work that way. 
2. Create a nix expression like `python.nix` with all dependencies for Python: 

```
with import <nixpkgs> {};

(python35.withPackages (ps: [ps.numpy ps.toolz])).env
```

3. Set up temporary Python environment with nix-shell: `$ nix-shell python.nix`
4. Run/execute any python script in `nix-shell`: `$ nix-shell python.nix --run "python3 mypyscript.py" `
5. Use imperative pip in a virtualenv like in other OS: 
```
with import <nixpkgs> {};
with python36Packages;

stdenv.mkDerivation {
  name = "impurePythonEnv";

  src = null;

  buildInputs = [
    # these packages are required for virtualenv and pip to work:
    #
    python36Full
    python36Packages.virtualenv
    python36Packages.pip
    # the following packages are related to the dependencies of your python
    # project.
    # In this particular example the python modules listed in the
    # requirements.txt require the following packages to be installed locally
    # in order to compile any binary extensions they may require.
    #
    taglib
    openssl
    git
    libxml2
    #libxslt #not available for python36
    libzip
    stdenv
    zlib
  ];

  shellHook = ''
    # set SOURCE_DATE_EPOCH so that we can use python wheels
    SOURCE_DATE_EPOCH=$(date +%s)
    virtualenv --no-setuptools venv
    export PATH=$PWD/venv/bin:$PATH
    pip install -r requirements.txt
  '';
}
```

6. In `requirements.txt` list whatever python modules e.g. matplotlib, pandas
7. Therefore you could look for packages e.g. numpy `$ nix-env -qa '.*numpy.*'`
