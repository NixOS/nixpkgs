# Python

## User Guide

Several versions of Python are available on Nix as well as a high amount of
packages. The default interpreter is CPython 3.5.

### Using Python

#### Installing Python and packages

It is important to make a distinction between Python packages that are
used as libraries, and applications that are written in Python.

Applications on Nix are installed typically into your user
profile imperatively using `nix-env -i`, and on NixOS declaratively by adding the
package name to `environment.systemPackages` in `/etc/nixos/configuration.nix`.
Dependencies such as libraries are automatically installed and should not be
installed explicitly.

The same goes for Python applications and libraries. Python applications can be
installed in your profile, but Python libraries you would like to use to develop
cannot. If you do install libraries in your profile, then you will end up with
import errors.

#### Python environments using `nix-shell`

The recommended method for creating Python environments for development is with
`nix-shell`. Executing

```sh
$ nix-shell -p python35Packages.numpy python35Packages.toolz
```

opens a Nix shell which has available the requested packages and dependencies.
Now you can launch the Python interpreter (which is itself a dependency)

```sh
[nix-shell:~] python3
```

If the packages were not available yet in the Nix store, Nix would download or
build them automatically. A convenient option with `nix-shell` is the `--run`
option, with which you can execute a command in the `nix-shell`. Let's say we
want the above environment and directly run the Python interpreter

```sh
$ nix-shell -p python35Packages.numpy python35Packages.toolz --run "python3"
```

This way you can use the `--run` option also to directly run a script

```sh
$ nix-shell -p python35Packages.numpy python35Packages.toolz --run "python3 myscript.py"
```

In fact, for this specific use case there is a more convenient method. You can
add a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) to your script
specifying which dependencies Nix shell needs. With the following shebang, you
can use `nix-shell myscript.py` and it will make available all dependencies and
run the script in the `python3` shell.

```py
#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.numpy

import numpy

print(numpy.__version__)
```

Likely you do not want to type your dependencies each and every time. What you
can do is write a simple Nix expression which sets up an environment for you,
requiring you only to type `nix-shell`. Say we want to have Python 3.5, `numpy`
and `toolz`, like before, in an environment. With a `shell.nix` file
containing

```nix
with import <nixpkgs> {};

(pkgs.python35.withPackages (ps: [ps.numpy ps.toolz])).env
```
executing `nix-shell` gives you again a Nix shell from which you can run Python.

What's happening here?

1. We begin with importing the Nix Packages collections. `import <nixpkgs>` import the `<nixpkgs>` function, `{}` calls it and the `with` statement brings all attributes of `nixpkgs` in the local scope. Therefore we can now use `pkgs`.
2. Then we create a Python 3.5 environment with the `withPackages` function.
3. The `withPackages` function expects us to provide a function as an argument that takes the set of all python packages and returns a list of packages to include in the environment. Here, we select the packages `numpy` and `toolz` from the package set.
4. And finally, for in interactive use we return the environment by using the `env` attribute.

### Developing with Python


Now that you know how to get a working Python environment on Nix, it is time to go forward and start actually developing with Python.
We will first have a look at how Python packages are packaged on Nix. Then, we will look how you can use development mode with your code.

#### Python packaging on Nix

On Nix all packages are built by functions. The main function in Nix for building Python packages is [`buildPythonPackage`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/interpreters/python/build-python-package.nix).
Let's see how we would build the `toolz` package. According to [`python-packages.nix`](https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/top-level/python-packages.nix) `toolz` is build using

```nix
toolz = buildPythonPackage rec{
  name = "toolz-${version}";
  version = "0.7.4";

  src = pkgs.fetchurl{
    url = "mirror://pypi/t/toolz/toolz-${version}.tar.gz";
    sha256 = "43c2c9e5e7a16b6c88ba3088a9bfc82f7db8e13378be7c78d6c14a5f8ed05afd";
  };

  meta = {
    homepage = "http://github.com/pytoolz/toolz/";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
};
```

What happens here? The function `buildPythonPackage` is called and as argument
it accepts a set. In this case the set is a recursive set ([`rec`](http://nixos.org/nix/manual/#sec-constructs)).
One of the arguments is the name of the package, which consists of a basename
(generally following the name on PyPi) and a version. Another argument, `src`
specifies the source, which in this case is fetched from an url. `fetchurl` not
only downloads the target file, but also validates its hash. Furthermore, we
specify some (optional) [meta information](http://nixos.org/nixpkgs/manual/#chap-meta).

The output of the function is a derivation, which is an attribute with the name
`toolz` of the set `pythonPackages`. Actually, sets are created for all interpreter versions,
so `python27Packages`, `python34Packages`, `python35Packages` and `pypyPackages`.

The above example works when you're directly working on
`pkgs/top-level/python-packages.nix` in the Nixpkgs repository. Often though,
you will want to test a Nix expression outside of the Nixpkgs tree. If you
create a `shell.nix` file with the following contents

```nix
with import <nixpkgs> {};

pkgs.python35Packages.buildPythonPackage rec {
  name = "toolz-${version}";
  version = "0.8.0";

  src = pkgs.fetchurl{
    url = "mirror://pypi/t/toolz/toolz-${version}.tar.gz";
    sha256 = "e8451af61face57b7c5d09e71c0d27b8005f001ead56e9fdf470417e5cc6d479";
  };

  doCheck = false;

  meta = {
    homepage = "http://github.com/pytoolz/toolz/";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
```

and then execute `nix-shell` will result in an environment in which you can use
Python 3.5 and the `toolz` package. As you can see we had to explicitly mention
for which Python version we want to build a package.

The above example considered only a single package. Generally you will want to use multiple packages.
If we create a `shell.nix` file with the following contents

```nix
with import <nixpkgs> {};

( let
    toolz = pkgs.python35Packages.buildPythonPackage rec {
      name = "toolz-${version}";
      version = "0.8.0";

      src = pkgs.fetchurl{
        url = "mirror://pypi/t/toolz/toolz-${version}.tar.gz";
        sha256 = "e8451af61face57b7c5d09e71c0d27b8005f001ead56e9fdf470417e5cc6d479";
      };

      doCheck = false;

      meta = {
        homepage = "http://github.com/pytoolz/toolz/";
        description = "List processing tools and functional utilities";
      };
    };

  in pkgs.python35.withPackages (ps: [ps.numpy toolz])
).env
```

and again execute `nix-shell`, then we get a Python 3.5 environment with our
locally defined package as well as `numpy` which is build according to the
definition in Nixpkgs. What did we do here? Well, we took the Nix expression
that we used earlier to build a Python environment, and said that we wanted to
include our own version of `toolz`. To introduce our own package in the scope of
`withPackages` we used a
[`let`](http://nixos.org/nix/manual/#sec-constructs) expression.
You can see that we used `ps.numpy` to select numpy from the nixpkgs package set (`ps`).
But we do not take `toolz` from the nixpkgs package set this time.
Instead, `toolz` will resolve to our local definition that we introduced with `let`.

### Handling dependencies

Our example, `toolz`, doesn't have any dependencies on other Python
packages or system libraries. According to the manual,  `buildPythonPackage`
uses the arguments `buildInputs` and `propagatedBuildInputs` to specify dependencies. If something is
exclusively a build-time dependency, then the dependency should be included as a
`buildInput`, but if it is (also) a runtime dependency, then it should be added
to `propagatedBuildInputs`. Test dependencies are considered build-time dependencies.

The following example shows which arguments are given to `buildPythonPackage` in
order to build [`datashape`](https://github.com/blaze/datashape).

```nix
datashape = buildPythonPackage rec {
  name = "datashape-${version}";
  version = "0.4.7";

  src = pkgs.fetchurl {
    url = "mirror://pypi/D/DataShape/${name}.tar.gz";
    sha256 = "14b2ef766d4c9652ab813182e866f493475e65e558bed0822e38bf07bba1a278";
  };

  buildInputs = with self; [ pytest ];
  propagatedBuildInputs = with self; [ numpy multipledispatch dateutil ];

  meta = {
    homepage = https://github.com/ContinuumIO/datashape;
    description = "A data description language";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fridh ];
  };
};
```

We can see several runtime dependencies, `numpy`, `multipledispatch`, and
`dateutil`. Furthermore, we have one `buildInput`, i.e. `pytest`. `pytest` is a
test runner and is only used during the `checkPhase` and is therefore not added
to `propagatedBuildInputs`.

In the previous case we had only dependencies on other Python packages to consider.
Occasionally you have also system libraries to consider. E.g., `lxml` provides
Python bindings to `libxml2` and `libxslt`. These libraries are only required
when building the bindings and are therefore added as `buildInputs`.

```nix
lxml = buildPythonPackage rec {
  name = "lxml-3.4.4";

  src = pkgs.fetchurl {
    url = "mirror://pypi/l/lxml/${name}.tar.gz";
    sha256 = "16a0fa97hym9ysdk3rmqz32xdjqmy4w34ld3rm3jf5viqjx65lxk";
  };

  buildInputs = with self; [ pkgs.libxml2 pkgs.libxslt ];

  meta = {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = http://lxml.de;
    license = licenses.bsd3;
    maintainers = with maintainers; [ sjourdois ];
  };
};
```

In this example `lxml` and Nix are able to work out exactly where the relevant
files of the dependencies are. This is not always the case.

The example below shows bindings to The Fastest Fourier Transform in the West, commonly known as
FFTW. On Nix we have separate packages of FFTW for the different types of floats
(`"single"`, `"double"`, `"long-double"`). The bindings need all three types,
and therefore we add all three as `buildInputs`. The bindings don't expect to
find each of them in a different folder, and therefore we have to set `LDFLAGS`
and `CFLAGS`.

```nix
pyfftw = buildPythonPackage rec {
  name = "pyfftw-${version}";
  version = "0.9.2";

  src = pkgs.fetchurl {
    url = "mirror://pypi/p/pyFFTW/pyFFTW-${version}.tar.gz";
    sha256 = "f6bbb6afa93085409ab24885a1a3cdb8909f095a142f4d49e346f2bd1b789074";
  };

  buildInputs = [ pkgs.fftw pkgs.fftwFloat pkgs.fftwLongDouble];

  propagatedBuildInputs = with self; [ numpy scipy ];

  # Tests cannot import pyfftw. pyfftw works fine though.
  doCheck = false;

  LDFLAGS="-L${pkgs.fftw.dev}/lib -L${pkgs.fftwFloat.out}/lib -L${pkgs.fftwLongDouble.out}/lib"
  CFLAGS="-I${pkgs.fftw.dev}/include -I${pkgs.fftwFloat.dev}/include -I${pkgs.fftwLongDouble.dev}/include"
  '';

  meta = {
    description = "A pythonic wrapper around FFTW, the FFT library, presenting a unified interface for all the supported transforms";
    homepage = http://hgomersall.github.com/pyFFTW/;
    license = with licenses; [ bsd2 bsd3 ];
    maintainer = with maintainers; [ fridh ];
  };
};
```
Note also the line `doCheck = false;`, we explicitly disabled running the test-suite.


#### Develop local package

As a Python developer you're likely aware of [development mode](http://setuptools.readthedocs.io/en/latest/setuptools.html#development-mode) (`python setup.py develop`);
instead of installing the package this command creates a special link to the project code.
That way, you can run updated code without having to reinstall after each and every change you make.
Development mode is also available. Let's see how you can use it.

In the previous Nix expression the source was fetched from an url. We can also refer to a local source instead using

```nix
src = ./path/to/source/tree;
```

If we create a `shell.nix` file which calls `buildPythonPackage`, and if `src`
is a local source, and if the local source has a `setup.py`, then development
mode is activated.

In the following example we create a simple environment that
has a Python 3.5 version of our package in it, as well as its dependencies and
other packages we like to have in the environment, all specified with `propagatedBuildInputs`.
Indeed, we can just add any package we like to have in our environment to `propagatedBuildInputs`.

```nix
with import <nixpkgs>;
with pkgs.python35Packages;

buildPythonPackage rec {
  name = "mypackage";
  src = ./path/to/package/source;
  propagatedBuildInputs = [ pytest numpy pkgs.libsndfile ];
};
```

It is important to note that due to how development mode is implemented on Nix it is not possible to have multiple packages simultaneously in development mode.


### Organising your packages

So far we discussed how you can use Python on Nix, and how you can develop with
it. We've looked at how you write expressions to package Python packages, and we
looked at how you can create environments in which specified packages are
available.

At some point you'll likely have multiple packages which you would
like to be able to use in different projects. In order to minimise unnecessary
duplication we now look at how you can maintain yourself a repository with your
own packages. The important functions here are `import` and `callPackage`.

### Including a derivation using `callPackage`

Earlier we created a Python environment using `withPackages`, and included the
`toolz` package via a `let` expression.
Let's split the package definition from the environment definition.

We first create a function that builds `toolz` in `~/path/to/toolz/release.nix`

```nix
{ pkgs, buildPythonPackage }:

buildPythonPackage rec {
  name = "toolz-${version}";
  version = "0.7.4";

  src = pkgs.fetchurl{
    url = "mirror://pypi/t/toolz/toolz-${version}.tar.gz";
    sha256 = "43c2c9e5e7a16b6c88ba3088a9bfc82f7db8e13378be7c78d6c14a5f8ed05afd";
  };

  meta = {
    homepage = "http://github.com/pytoolz/toolz/";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
};
```

It takes two arguments, `pkgs` and `buildPythonPackage`.
We now call this function using `callPackage` in the definition of our environment

```nix
with import <nixpkgs> {};

( let
    toolz = pkgs.callPackage ~/path/to/toolz/release.nix { pkgs=pkgs; buildPythonPackage=pkgs.python35Packages.buildPythonPackage; };
  in pkgs.python35.withPackages (ps: [ ps.numpy toolz ])
).env
```

Important to remember is that the Python version for which the package is made
depends on the `python` derivation that is passed to `buildPythonPackage`. Nix
tries to automatically pass arguments when possible, which is why generally you
don't explicitly define which `python` derivation should be used. In the above
example we use `buildPythonPackage` that is part of the set `python35Packages`,
and in this case the `python35` interpreter is automatically used.



## Reference

### Interpreters

Versions 2.6, 2.7, 3.3, 3.4 and 3.5 of the CPython interpreter are available as respectively
`python26`, `python27`, `python33`, `python34` and `python35`. The PyPy interpreter
is available as `pypy`. The aliases `python2` and `python3` correspond to respectively `python27` and
`python35`. The default interpreter, `python`, maps to `python2`.
The Nix expressions for the interpreters can be found in
`pkgs/development/interpreters/python`.

All packages depending on any Python interpreter get appended
`out/{python.sitePackages}` to `$PYTHONPATH` if such directory
exists.

#### Missing `tkinter` module standard library

To reduce closure size the `Tkinter`/`tkinter` is available as a separate package, `pythonPackages.tkinter`.

#### Attributes on interpreters packages

Each interpreter has the following attributes:

- `libPrefix`. Name of the folder in `${python}/lib/` for corresponding interpreter.
- `interpreter`. Alias for `${python}/bin/${executable}`.
- `buildEnv`. Function to build python interpreter environments with extra packages bundled together. See section *python.buildEnv function* for usage and documentation.
- `withPackages`. Simpler interface to `buildEnv`. See section *python.withPackages function* for usage and documentation.
- `sitePackages`. Alias for `lib/${libPrefix}/site-packages`.
- `executable`. Name of the interpreter executable, e.g. `python3.4`.
- `pkgs`. Set of Python packages for that specific interpreter. The package set can be modified by overriding the interpreter and passing `packageOverrides`.

### Building packages and applications

Python libraries and applications that use `setuptools` or
`distutils` are typically build with respectively the `buildPythonPackage` and
`buildPythonApplication` functions. These two functions also support installing a `wheel`.

All Python packages reside in `pkgs/top-level/python-packages.nix` and all
applications elsewhere. In case a package is used as both a library and an application,
then the package should be in `pkgs/top-level/python-packages.nix` since only those packages are made
available for all interpreter versions. The preferred location for library expressions is in
`pkgs/development/python-modules`. It is important that these packages are
called from `pkgs/top-level/python-packages.nix` and not elsewhere, to guarantee
the right version of the package is built.

Based on the packages defined in `pkgs/top-level/python-packages.nix` an
attribute set is created for each available Python interpreter. The available
sets are

* `pkgs.python26Packages`
* `pkgs.python27Packages`
* `pkgs.python33Packages`
* `pkgs.python34Packages`
* `pkgs.python35Packages`
* `pkgs.pypyPackages`

and the aliases

* `pkgs.python2Packages` pointing to `pkgs.python27Packages`
* `pkgs.python3Packages` pointing to `pkgs.python35Packages`
* `pkgs.pythonPackages` pointing to `pkgs.python2Packages`

#### `buildPythonPackage` function

The `buildPythonPackage` function is implemented in
`pkgs/development/interpreters/python/build-python-package.nix`

The following is an example:

    twisted = buildPythonPackage {
      name = "twisted-8.1.0";

      src = pkgs.fetchurl {
        url = http://tmrc.mit.edu/mirror/twisted/Twisted/8.1/Twisted-8.1.0.tar.bz2;
        sha256 = "0q25zbr4xzknaghha72mq57kh53qw1bf8csgp63pm9sfi72qhirl";
      };

      propagatedBuildInputs = [ self.ZopeInterface ];

      meta = {
        homepage = http://twistedmatrix.com/;
        description = "Twisted, an event-driven networking engine written in Python";
        license = stdenv.lib.licenses.mit; };
      };

The `buildPythonPackage` mainly does four things:

* In the `buildPhase`, it calls `${python.interpreter} setup.py bdist_wheel` to
  build a wheel binary zipfile.
* In the `installPhase`, it installs the wheel file using `pip install *.whl`.
* In the `postFixup` phase, the `wrapPythonPrograms` bash function is called to
  wrap all programs in the `$out/bin/*` directory to include `$PATH`
  environment variable and add dependent libraries to script's `sys.path`.
* In the `installCheck` phase, `${python.interpreter} setup.py test` is ran.

As in Perl, dependencies on other Python packages can be specified in the
`buildInputs` and `propagatedBuildInputs` attributes.  If something is
exclusively a build-time dependency, use `buildInputs`; if it’s (also) a runtime
dependency, use `propagatedBuildInputs`.

By default tests are run because `doCheck = true`. Test dependencies, like
e.g. the test runner, should be added to `buildInputs`.

By default `meta.platforms` is set to the same value
as the interpreter unless overriden otherwise.

##### `buildPythonPackage` parameters

All parameters from `mkDerivation` function are still supported.

* `namePrefix`: Prepended text to `${name}` parameter. Defaults to `"python3.3-"` for Python 3.3, etc. Set it to `""` if you're packaging an application or a command line tool.
* `disabled`: If `true`, package is not build for particular python interpreter version. Grep around `pkgs/top-level/python-packages.nix` for examples.
* `setupPyBuildFlags`: List of flags passed to `setup.py build_ext` command.
* `pythonPath`: List of packages to be added into `$PYTHONPATH`. Packages in `pythonPath` are not propagated (contrary to `propagatedBuildInputs`).
* `preShellHook`: Hook to execute commands before `shellHook`.
* `postShellHook`: Hook to execute commands after `shellHook`.
* `makeWrapperArgs`: A list of strings. Arguments to be passed to `makeWrapper`, which wraps generated binaries. By default, the arguments to `makeWrapper` set `PATH` and `PYTHONPATH` environment variables before calling the binary. Additional arguments here can allow a developer to set environment variables which will be available when the binary is run. For example, `makeWrapperArgs = ["--set FOO BAR" "--set BAZ QUX"]`.
* `installFlags`: A list of strings. Arguments to be passed to `pip install`. To pass options to `python setup.py install`, use `--install-option`. E.g., `installFlags=["--install-option='--cpp_implementation'"].
* `format`: Format of the source. Valid options are `setuptools` (default), `flit`, `wheel`, and `other`. `setuptools` is for when the source has a `setup.py` and `setuptools` is used to build a wheel, `flit`, in case `flit` should be used to build a wheel, and `wheel` in case a wheel is provided. In case you need to provide your own `buildPhase` and `installPhase` you can use `other`.
* `catchConflicts` If `true`, abort package build if a package name appears more than once in dependency tree. Default is `true`.
* `checkInputs` Dependencies needed for running the `checkPhase`. These are added to `buildInputs` when `doCheck = true`.

#### `buildPythonApplication` function

The `buildPythonApplication` function is practically the same as `buildPythonPackage`.
The difference is that `buildPythonPackage` by default prefixes the names of the packages with the version of the interpreter.
Because with an application we're not interested in multiple version the prefix is dropped.

#### python.buildEnv function

Python environments can be created using the low-level `pkgs.buildEnv` function.
This example shows how to create an environment that has the Pyramid Web Framework.
Saving the following as `default.nix`

    with import <nixpkgs> {};

    python.buildEnv.override {
      extraLibs = [ pkgs.pythonPackages.pyramid ];
      ignoreCollisions = true;
    }

and running `nix-build` will create

    /nix/store/cf1xhjwzmdki7fasgr4kz6di72ykicl5-python-2.7.8-env

with wrapped binaries in `bin/`.

You can also use the `env` attribute to create local environments with needed
packages installed. This is somewhat comparable to `virtualenv`. For example,
running `nix-shell` with the following `shell.nix`

    with import <nixpkgs> {};

    (python3.buildEnv.override {
      extraLibs = with python3Packages; [ numpy requests2 ];
    }).env

will drop you into a shell where Python will have the
specified packages in its path.


##### `python.buildEnv` arguments

* `extraLibs`: List of packages installed inside the environment.
* `postBuild`: Shell command executed after the build of environment.
* `ignoreCollisions`: Ignore file collisions inside the environment (default is `false`).

#### python.withPackages function

The `python.withPackages` function provides a simpler interface to the `python.buildEnv` functionality.
It takes a function as an argument that is passed the set of python packages and returns the list
of the packages to be included in the environment. Using the `withPackages` function, the previous
example for the Pyramid Web Framework environment can be written like this:

    with import <nixpkgs> {};

    python.withPackages (ps: [ps.pyramid])

`withPackages` passes the correct package set for the specific interpreter version as an
argument to the function. In the above example, `ps` equals `pythonPackages`.
But you can also easily switch to using python3:

    with import <nixpkgs> {};

    python3.withPackages (ps: [ps.pyramid])

Now, `ps` is set to `python3Packages`, matching the version of the interpreter.

As `python.withPackages` simply uses `python.buildEnv` under the hood, it also supports the `env`
attribute. The `shell.nix` file from the previous section can thus be also written like this:

    with import <nixpkgs> {};

    (python33.withPackages (ps: [ps.numpy ps.requests2])).env

In contrast to `python.buildEnv`, `python.withPackages` does not support the more advanced options
such as `ignoreCollisions = true` or `postBuild`. If you need them, you have to use `python.buildEnv`.

### Development mode

Development or editable mode is supported. To develop Python packages
`buildPythonPackage` has additional logic inside `shellPhase` to run `pip
install -e . --prefix $TMPDIR/`for the package.

Warning: `shellPhase` is executed only if `setup.py` exists.

Given a `default.nix`:

    with import <nixpkgs> {};

    buildPythonPackage { name = "myproject";

    buildInputs = with pkgs.pythonPackages; [ pyramid ];

    src = ./.; }

Running `nix-shell` with no arguments should give you
the environment in which the package would be built with
`nix-build`.

Shortcut to setup environments with C headers/libraries and python packages:

    $ nix-shell -p pythonPackages.pyramid zlib libjpeg git

Note: There is a boolean value `lib.inNixShell` set to `true` if nix-shell is invoked.

### Tools

Packages inside nixpkgs are written by hand. However many tools exist in
community to help save time. No tool is preferred at the moment.

- [python2nix](https://github.com/proger/python2nix) by Vladimir Kirillov
- [pypi2nix](https://github.com/garbas/pypi2nix) by Rok Garbas
- [pypi2nix](https://github.com/offlinehacker/pypi2nix) by Jaka Hudoklin

### Deterministic builds

Python 2.7, 3.5 and 3.6 are now built deterministically and 3.4 mostly.
Minor modifications had to be made to the interpreters in order to generate
deterministic bytecode. This has security implications and is relevant for
those using Python in a `nix-shell`.

When the environment variable `DETERMINISTIC_BUILD` is set, all bytecode will have timestamp 1.
The `buildPythonPackage` function sets `DETERMINISTIC_BUILD` as well as
[PYTHONHASHSEED](https://docs.python.org/3.5/using/cmdline.html#envvar-PYTHONHASHSEED).
Both are also exported in `nix-shell`.


## FAQ

### How can I install a working Python environment?

As explained in the user's guide installing individual Python packages
imperatively with `nix-env -i` or declaratively in `environment.systemPackages`
is not supported. However, it is possible to install a Python environment with packages (`python.buildEnv`).

In the following examples we create an environment with Python 3.5, `numpy` and `ipython`.
As you might imagine there is one limitation here, and that's you can install
only one environment at a time. You will notice the complaints about collisions
when you try to install a second environment.

#### Environment defined in separate `.nix` file

Create a file, e.g. `build.nix`, with the following expression
```nix
with import <nixpkgs> {};

pkgs.python35.withPackages (ps: with ps; [ numpy ipython ])
```
and install it in your profile with
```
nix-env -if build.nix
```
Now you can use the Python interpreter, as well as the extra packages that you added to the environment.

#### Environment defined in `~/.nixpkgs/config.nix`

If you prefer to, you could also add the environment as a package override to the Nixpkgs set.
```
  packageOverrides = pkgs: with pkgs; {
    myEnv = python35.withPackages (ps: with ps; [ numpy ipython ]);
  };
```
and install it in your profile with
```
nix-env -iA nixpkgs.myEnv
```
We're installing using the attribute path and assume the channels is named `nixpkgs`.
Note that I'm using the attribute path here.

#### Environment defined in `/etc/nixos/configuration.nix`

For the sake of completeness, here's another example how to install the environment system-wide.

```nix
environment.systemPackages = with pkgs; [
  (python35.withPackages(ps: with ps; [ numpy ipython ]))
];
```

### How to solve circular dependencies?

Consider the packages `A` and `B` that depend on each other. When packaging `B`,
a solution is to override package `A` not to depend on `B` as an input. The same
should also be done when packaging `A`.

### How to override a Python package?

We can override the interpreter and pass `packageOverrides`.
In the following example we rename the `pandas` package and build it.
```nix
with import <nixpkgs> {};

let
  python = let
    packageOverrides = self: super: {
      pandas = super.pandas.override {name="foo";};
    };
  in pkgs.python35.override {inherit packageOverrides;};

in python.pkgs.pandas
```
Using `nix-build` on this expression will build the package `pandas`
but with the new name `foo`.

All packages in the package set will use the renamed package.
A typical use case is to switch to another version of a certain package.
For example, in the Nixpkgs repository we have multiple versions of `django` and `scipy`.
In the following example we use a different version of `scipy` and create an environment that uses it.
All packages in the Python package set will now use the updated `scipy` version.

```nix
with import <nixpkgs> {};

(
let
  packageOverrides = self: super: {
    scipy = super.scipy_0_17;
  };
in (pkgs.python35.override {inherit packageOverrides;}).withPackages (ps: [ps.blaze])
).env
```
The requested package `blaze` depends on `pandas` which itself depends on `scipy`.

If you want the whole of Nixpkgs to use your modifications, then you can use `overlays`
as explained in this manual. In the following example we build a `inkscape` using a different version of `numpy`.
```
let
  pkgs = import <nixpkgs> {};
  newpkgs = import pkgs.path { overlays = [ (pkgsself: pkgssuper: {
    python27 = let
      packageOverrides = self: super: {
        numpy = super.numpy_1_10;
      };
    in pkgssuper.python27.override {inherit packageOverrides;};
  } ) ]; };
in newpkgs.inkscape
```

### `python setup.py bdist_wheel` cannot create .whl

Executing `python setup.py bdist_wheel` in a `nix-shell `fails with
```
ValueError: ZIP does not support timestamps before 1980
```
This is because files are included that depend on items in the Nix store which have a timestamp of, that is, it corresponds to January the 1st, 1970 at 00:00:00. And as the error informs you, ZIP does not support that.
The command `bdist_wheel` takes into account `SOURCE_DATE_EPOCH`, and `nix-shell` sets this to 1. By setting it to a value corresponding to 1980 or later, or by unsetting it, it is possible to build wheels.

Use 1980 as timestamp:
```
nix-shell --run "SOURCE_DATE_EPOCH=315532800 python3 setup.py bdist_wheel"
```
or the current time:
```
nix-shell --run "SOURCE_DATE_EPOCH=$(date +%s) python3 setup.py bdist_wheel"
```
or unset:
```
nix-shell --run "unset SOURCE_DATE_EPOCH; python3 setup.py bdist_wheel"
```

### `install_data` / `data_files` problems

If you get the following error:

    could not create '/nix/store/6l1bvljpy8gazlsw2aw9skwwp4pmvyxw-python-2.7.8/etc':
    Permission denied

This is a [known bug](https://github.com/pypa/setuptools/issues/130) in setuptools.
Setuptools `install_data` does not respect `--prefix`. An example of such package using the feature is `pkgs/tools/X11/xpra/default.nix`.
As workaround install it as an extra `preInstall` step:

    ${python.interpreter} setup.py install_data --install-dir=$out --root=$out
    sed -i '/ = data\_files/d' setup.py


###  Rationale of non-existent global site-packages

On most operating systems a global `site-packages` is maintained. This however
becomes problematic if you want to run multiple Python versions or have multiple
versions of certain libraries for your projects. Generally, you would solve such
issues by creating virtual environments using `virtualenv`.

On Nix each package has an isolated dependency tree which, in the case of
Python, guarantees the right versions of the interpreter and libraries or
packages are available. There is therefore no need to maintain a global `site-packages`.

If you want to create a Python environment for development, then the recommended
method is to use `nix-shell`, either with or without the `python.buildEnv`
function.

### How to consume python modules using pip in a virtualenv like I am used to on other Operating Systems ?

This is an example of a `default.nix` for a `nix-shell`, which allows to consume a `virtualenv` environment,
and install python modules through `pip` the traditional way.

Create this `default.nix` file, together with a `requirements.txt` and simply execute `nix-shell`.

```
with import <nixpkgs> {};
with pkgs.python27Packages;

stdenv.mkDerivation {
  name = "impurePythonEnv";
  buildInputs = [
    # these packages are required for virtualenv and pip to work:
    #
    python27Full
    python27Packages.virtualenv
    python27Packages.pip
    # the following packages are related to the dependencies of your python
    # project.
    # In this particular example the python modules listed in the
    # requirements.tx require the following packages to be installed locally
    # in order to compile any binary extensions they may require.
    #
    taglib
    openssl
    git
    libxml2
    libxslt
    libzip
    stdenv
    zlib ];
  src = null;
  shellHook = ''
  # set SOURCE_DATE_EPOCH so that we can use python wheels
  SOURCE_DATE_EPOCH=$(date +%s)
  virtualenv --no-setuptools venv
  export PATH=$PWD/venv/bin:$PATH
  pip install -r requirements.txt
  '';
}
```

Note that the `pip install` is an imperative action. So every time `nix-shell`
is executed it will attempt to download the python modules listed in
requirements.txt. However these will be cached locally within the `virtualenv`
folder and not downloaded again.


## Contributing

### Contributing guidelines

Following rules are desired to be respected:

* Python libraries are supposed to be called from `python-packages.nix` and packaged with `buildPythonPackage`. The expression of a library should be in `pkgs/development/python-modules/<name>/default.nix`. Libraries in `pkgs/top-level/python-packages.nix` are sorted quasi-alphabetically to avoid merge conflicts.
* Python applications live outside of `python-packages.nix` and are packaged with `buildPythonApplication`.
* Make sure libraries build for all Python interpreters.
* By default we enable tests. Make sure the tests are found and, in the case of libraries, are passing for all interpreters. If certain tests fail they can be disabled individually. Try to avoid disabling the tests altogether. In any case, when you disable tests, leave a comment explaining why.
* Commit names of Python libraries should include `pythonPackages`, for example `pythonPackages.numpy: 1.11 -> 1.12`.
