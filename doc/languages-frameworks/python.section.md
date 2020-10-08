# Python

## User Guide

### Using Python

#### Overview

Several versions of the Python interpreter are available on Nix, as well as a
high amount of packages. The attribute `python` refers to the default
interpreter, which is currently CPython 2.7. It is also possible to refer to
specific versions, e.g. `python38` refers to CPython 3.8, and `pypy` refers to
the default PyPy interpreter.

Python is used a lot, and in different ways. This affects also how it is
packaged. In the case of Python on Nix, an important distinction is made between
whether the package is considered primarily an application, or whether it should
be used as a library, i.e., of primary interest are the modules in
`site-packages` that should be importable.

In the Nixpkgs tree Python applications can be found throughout, depending on
what they do, and are called from the main package set. Python libraries,
however, are in separate sets, with one set per interpreter version.

The interpreters have several common attributes. One of these attributes is
`pkgs`, which is a package set of Python libraries for this specific
interpreter. E.g., the `toolz` package corresponding to the default interpreter
is `python.pkgs.toolz`, and the CPython 3.8 version is `python38.pkgs.toolz`.
The main package set contains aliases to these package sets, e.g.
`pythonPackages` refers to `python.pkgs` and `python38Packages` to
`python38.pkgs`.

#### Installing Python and packages

The Nix and NixOS manuals explain how packages are generally installed. In the
case of Python and Nix, it is important to make a distinction between whether the
package is considered an application or a library.

Applications on Nix are typically installed into your user profile imperatively
using `nix-env -i`, and on NixOS declaratively by adding the package name to
`environment.systemPackages` in `/etc/nixos/configuration.nix`. Dependencies
such as libraries are automatically installed and should not be installed
explicitly.

The same goes for Python applications. Python applications can be installed in
your profile, and will be wrapped to find their exact library dependencies,
without impacting other applications or polluting your user environment.

But Python libraries you would like to use for development cannot be installed,
at least not individually, because they won't be able to find each other
resulting in import errors. Instead, it is possible to create an environment
with `python.buildEnv` or `python.withPackages` where the interpreter and other
executables are wrapped to be able to find each other and all of the modules.

In the following examples we will start by creating a simple, ad-hoc environment
with a nix-shell that has `numpy` and `toolz` in Python 3.8; then we will create
a re-usable environment in a single-file Python script; then we will create a
full Python environment for development with this same environment.

Philosphically, this should be familiar to users who are used to a `venv` style
of development: individual projects create their own Python environments without
impacting the global environment or each other.

#### Ad-hoc temporary Python environment with `nix-shell`

The simplest way to start playing with the way nix wraps and sets up Python
environments is with `nix-shell` at the cmdline. These environments create a
temporary shell session with a Python and a *precise* list of packages (plus
their runtime dependencies), with no other Python packages in the Python
interpreter's scope.

To create a Python 3.8 session with `numpy` and `toolz` available, run:

```sh
$ nix-shell -p 'python38.withPackages(ps: with ps; [ numpy toolz ])'
```

By default `nix-shell` will start a `bash` session with this interpreter in our
`PATH`, so if we then run:

```
[nix-shell:~/src/nixpkgs]$ python3
Python 3.8.1 (default, Dec 18 2019, 19:06:26)
[GCC 9.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import numpy; import toolz
```

Note that no other modules are in scope, even if they were imperatively
installed into our user environment as a dependency of a Python application:

```
>>> import requests
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ModuleNotFoundError: No module named 'requests'
```

We can add as many additional modules onto the `nix-shell` as we need, and we
will still get 1 wrapped Python interpreter. We can start the interpreter
directly like so:

```sh
$ nix-shell -p 'python38.withPackages(ps: with ps; [ numpy toolz requests ])' --run python3
these derivations will be built:
  /nix/store/xbdsrqrsfa1yva5s7pzsra8k08gxlbz1-python3-3.8.1-env.drv
building '/nix/store/xbdsrqrsfa1yva5s7pzsra8k08gxlbz1-python3-3.8.1-env.drv'...
created 277 symlinks in user environment
Python 3.8.1 (default, Dec 18 2019, 19:06:26)
[GCC 9.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import requests
>>>
```

Notice that this time it built a new Python environment, which now includes
`requests`. Building an environment just creates wrapper scripts that expose the
selected dependencies to the interpreter while re-using the actual modules. This
means if any other env has installed `requests` or `numpy` in a different
context, we don't need to recompile them -- we just recompile the wrapper script
that sets up an interpreter pointing to them. This matters much more for "big"
modules like `pytorch` or `tensorflow`.

Module names usually match their names on [pypi.org](https://pypi.org/), but
you can use the [Nixpkgs search website](https://nixos.org/nixos/packages.html)
to find them as well (along with non-python packages).

At this point we can create throwaway experimental Python environments with
arbitrary dependencies. This is a good way to get a feel for how the Python
interpreter and dependencies work in Nix and NixOS, but to do some actual
development, we'll want to make it a bit more persistent.

##### Running Python scripts and using `nix-shell` as shebang

Sometimes, we have a script whose header looks like this:

```python
#!/usr/bin/env python3
import numpy as np
a = np.array([1,2])
b = np.array([3,4])
print(f"The dot product of {a} and {b} is: {np.dot(a, b)}")
```

Executing this script requires a `python3` that has `numpy`. Using what we learned
in the previous section, we could startup a shell and just run it like so:

```
nix-shell -p 'python38.withPackages(ps: with ps; [ numpy ])' --run 'python3 foo.py'
The dot product of [1 2] and [3 4] is: 11
```

But if we maintain the script ourselves, and if there are more dependencies, it
may be nice to encode those dependencies in source to make the script re-usable
without that bit of knowledge. That can be done by using `nix-shell` as a
[shebang](https://en.wikipedia.org/wiki/Shebang_(Unix), like so:

```python
#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.numpy ])"
import numpy as np
a = np.array([1,2])
b = np.array([3,4])
print(f"The dot product of {a} and {b} is: {np.dot(a, b)}")
```

Then we simply execute it, without requiring any environment setup at all!

```sh
$ ./foo.py
The dot product of [1 2] and [3 4] is: 11
```

If the dependencies are not available on the host where `foo.py` is executed, it
will build or download them from a Nix binary cache prior to starting up, prior
that it is executed on a machine with a multi-user nix installation.

This provides a way to ship a self bootstrapping Python script, akin to a
statically linked binary, where it can be run on any machine (provided nix is
installed) without having to assume that `numpy` is installed globally on the
system.

By default it is pulling the import checkout of Nixpkgs itself from our nix
channel, which is nice as it cache aligns with our other package builds, but we
can make it fully reproducible by pinning the `nixpkgs` import:

```python
#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: [ ps.numpy ])"
#!nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/d373d80b1207d52621961b16aa4a3438e4f98167.tar.gz
import numpy as np
a = np.array([1,2])
b = np.array([3,4])
print(f"The dot product of {a} and {b} is: {np.dot(a, b)}")
```

This will execute with the exact same versions of Python 3.8, numpy, and system
dependencies a year from now as it does today, because it will always use
exactly git commit `d373d80b1207d52621961b16aa4a3438e4f98167` of Nixpkgs for all
of the package versions.

This is also a great way to ensure the script executes identically on different
servers.

##### Load environment from `.nix` expression

We've now seen how to create an ad-hoc temporary shell session, and how to
create a single script with Python dependencies, but in the course of normal
development we're usually working in an entire package repository.

As explained in the Nix manual, `nix-shell` can also load an expression from a
`.nix` file. Say we want to have Python 3.8, `numpy` and `toolz`, like before,
in an environment. We can add a `shell.nix` file describing our dependencies:

```nix
with import <nixpkgs> {};
(python38.withPackages (ps: [ps.numpy ps.toolz])).env
```

And then at the command line, just typing `nix-shell` produces the same
environment as before. In a normal project, we'll likely have many more
dependencies; this can provide a way for developers to share the environments
with each other and with CI builders.

What's happening here?

1. We begin with importing the Nix Packages collections. `import <nixpkgs>`
   imports the `<nixpkgs>` function, `{}` calls it and the `with` statement
   brings all attributes of `nixpkgs` in the local scope. These attributes form
   the main package set.
2. Then we create a Python 3.8 environment with the `withPackages` function, as before.
3. The `withPackages` function expects us to provide a function as an argument
   that takes the set of all Python packages and returns a list of packages to
   include in the environment. Here, we select the packages `numpy` and `toolz`
   from the package set.

To combine this with `mkShell` you can:

```nix
with import <nixpkgs> {};
let
  pythonEnv = python38.withPackages (ps: [
    ps.numpy
    ps.toolz
  ]);
in mkShell {
  buildInputs = [
    pythonEnv

    black
    mypy

    libffi
    openssl
  ];
}
```

This will create a unified environment that has not just our Python interpreter
and its Python dependencies, but also tools like `black` or `mypy` and libraries
like `libffi` the `openssl` in scope. This is generic and can span any number of
tools or languages across the Nixpkgs ecosystem.

##### Installing environments globally on the system

Up to now, we've been creating environments scoped to an ad-hoc shell session,
or a single script, or a single project. This is generally advisable, as it
avoids pollution across contexts.

However, sometimes we know we will often want a Python with some basic packages,
and want this available without having to enter into a shell or build context.
This can be useful to have things like vim/emacs editors and plugins or shell
tools "just work" without having to set them up, or when running other software
that expects packages to be installed globally.

To create your own custom environment, create a file in `~/.config/nixpkgs/overlays/`
that looks like this:

```nix
# ~/.config/nixpkgs/overlays/myEnv.nix
self: super: {
  myEnv = super.buildEnv {
    name = "myEnv";
    paths = [
      # A Python 3 interpreter with some packages
      (self.python3.withPackages (
        ps: with ps; [
          pyflakes
          pytest
          python-language-server
        ]
      ))

      # Some other packages we'd like as part of this env
      self.mypy
      self.black
      self.ripgrep
      self.tmux
    ];
  };
}
```

You can then build and install this to your profile with:

```sh
nix-env -iA myEnv
```

One limitation of this is that you can only have 1 Python env installed
globally, since they conflict on the `python` to load out of your `PATH`.

If you get a conflict or prefer to keep the setup clean, you can have `nix-env`
atomically *uninstall* all other imperatively installed packages and replace
your profile with just `myEnv` by using the `--replace` flag.

##### Environment defined in `/etc/nixos/configuration.nix`

For the sake of completeness, here's how to install the environment system-wide
on NixOS.

```nix
{ # ...

  environment.systemPackages = with pkgs; [
    (python38.withPackages(ps: with ps; [ numpy toolz ]))
  ];
}
```

### Developing with Python

Above, we were mostly just focused on use cases and what to do to get started
creating working Python environments in nix.

Now that you know the basics to be up and running, it is time to take a step
back and take a deeper look at at how Python packages are packaged on Nix. Then,
we will look at how you can use development mode with your code.

#### Python library packages in Nixpkgs

With Nix all packages are built by functions. The main function in Nix for
building Python libraries is `buildPythonPackage`. Let's see how we can build the
`toolz` package.

```nix
{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "toolz";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08fdd5ef7c96480ad11c12d472de21acd32359996f69a5259299b540feba4560";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
```

What happens here? The function `buildPythonPackage` is called and as argument
it accepts a set. In this case the set is a recursive set, `rec`. One of the
arguments is the name of the package, which consists of a basename (generally
following the name on PyPi) and a version. Another argument, `src` specifies the
source, which in this case is fetched from PyPI using the helper function
`fetchPypi`. The argument `doCheck` is used to set whether tests should be run
when building the package. Furthermore, we specify some (optional) meta
information. The output of the function is a derivation.

An expression for `toolz` can be found in the Nixpkgs repository. As explained
in the introduction of this Python section, a derivation of `toolz` is available
for each interpreter version, e.g. `python38.pkgs.toolz` refers to the `toolz`
derivation corresponding to the CPython 3.8 interpreter.

The above example works when you're directly working on
`pkgs/top-level/python-packages.nix` in the Nixpkgs repository. Often though,
you will want to test a Nix expression outside of the Nixpkgs tree.

The following expression creates a derivation for the `toolz` package,
and adds it along with a `numpy` package to a Python environment.

```nix
with import <nixpkgs> {};

( let
    my_toolz = python38.pkgs.buildPythonPackage rec {
      pname = "toolz";
      version = "0.10.0";

      src = python38.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "08fdd5ef7c96480ad11c12d472de21acd32359996f69a5259299b540feba4560";
      };

      doCheck = false;

      meta = {
        homepage = "https://github.com/pytoolz/toolz/";
        description = "List processing tools and functional utilities";
      };
    };

  in python38.withPackages (ps: [ps.numpy my_toolz])
).env
```

Executing `nix-shell` will result in an environment in which you can use
Python 3.8 and the `toolz` package. As you can see we had to explicitly mention
for which Python version we want to build a package.

So, what did we do here? Well, we took the Nix expression that we used earlier
to build a Python environment, and said that we wanted to include our own
version of `toolz`, named `my_toolz`. To introduce our own package in the scope
of `withPackages` we used a `let` expression. You can see that we used
`ps.numpy` to select numpy from the nixpkgs package set (`ps`). We did not take
`toolz` from the Nixpkgs package set this time, but instead took our own version
that we introduced with the `let` expression.

#### Handling dependencies

Our example, `toolz`, does not have any dependencies on other Python packages or
system libraries. According to the manual, `buildPythonPackage` uses the
arguments `buildInputs` and `propagatedBuildInputs` to specify dependencies. If
something is exclusively a build-time dependency, then the dependency should be
included in `buildInputs`, but if it is (also) a runtime dependency, then it
should be added to `propagatedBuildInputs`. Test dependencies are considered
build-time dependencies and passed to `checkInputs`.

The following example shows which arguments are given to `buildPythonPackage` in
order to build [`datashape`](https://github.com/blaze/datashape).

```nix
{ lib, buildPythonPackage, fetchPypi, numpy, multipledispatch, dateutil, pytest }:

buildPythonPackage rec {
  pname = "datashape";
  version = "0.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14b2ef766d4c9652ab813182e866f493475e65e558bed0822e38bf07bba1a278";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy multipledispatch dateutil ];

  meta = with lib; {
    homepage = "https://github.com/ContinuumIO/datashape";
    description = "A data description language";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fridh ];
  };
}
```

We can see several runtime dependencies, `numpy`, `multipledispatch`, and
`dateutil`. Furthermore, we have one `checkInputs`, i.e. `pytest`. `pytest` is a
test runner and is only used during the `checkPhase` and is therefore not added
to `propagatedBuildInputs`.

In the previous case we had only dependencies on other Python packages to consider.
Occasionally you have also system libraries to consider. E.g., `lxml` provides
Python bindings to `libxml2` and `libxslt`. These libraries are only required
when building the bindings and are therefore added as `buildInputs`.

```nix
{ lib, pkgs, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "lxml";
  version = "3.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16a0fa97hym9ysdk3rmqz32xdjqmy4w34ld3rm3jf5viqjx65lxk";
  };

  buildInputs = [ pkgs.libxml2 pkgs.libxslt ];

  meta = with lib; {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = "https://lxml.de";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sjourdois ];
  };
}
```

In this example `lxml` and Nix are able to work out exactly where the relevant
files of the dependencies are. This is not always the case.

The example below shows bindings to The Fastest Fourier Transform in the West,
commonly known as FFTW. On Nix we have separate packages of FFTW for the
different types of floats (`"single"`, `"double"`, `"long-double"`). The
bindings need all three types, and therefore we add all three as `buildInputs`.
The bindings don't expect to find each of them in a different folder, and
therefore we have to set `LDFLAGS` and `CFLAGS`.

```nix
{ lib, pkgs, buildPythonPackage, fetchPypi, numpy, scipy }:

buildPythonPackage rec {
  pname = "pyFFTW";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6bbb6afa93085409ab24885a1a3cdb8909f095a142f4d49e346f2bd1b789074";
  };

  buildInputs = [ pkgs.fftw pkgs.fftwFloat pkgs.fftwLongDouble];

  propagatedBuildInputs = [ numpy scipy ];

  # Tests cannot import pyfftw. pyfftw works fine though.
  doCheck = false;

  preConfigure = ''
    export LDFLAGS="-L${pkgs.fftw.dev}/lib -L${pkgs.fftwFloat.out}/lib -L${pkgs.fftwLongDouble.out}/lib"
    export CFLAGS="-I${pkgs.fftw.dev}/include -I${pkgs.fftwFloat.dev}/include -I${pkgs.fftwLongDouble.dev}/include"
  '';

  meta = with lib; {
    description = "A pythonic wrapper around FFTW, the FFT library, presenting a unified interface for all the supported transforms";
    homepage = "http://hgomersall.github.com/pyFFTW";
    license = with licenses; [ bsd2 bsd3 ];
    maintainers = with maintainers; [ fridh ];
  };
}
```
Note also the line `doCheck = false;`, we explicitly disabled running the test-suite.

#### Testing Python Packages

It is highly encouraged to have testing as part of the package build. This
helps to avoid situations where the package was able to build and install,
but is not usable at runtime. Currently, all packages will use the `test`
command provided by the setup.py (i.e. `python setup.py test`). However,
this is currently deprecated https://github.com/pypa/setuptools/pull/1878
and your package should provide its own checkPhase.

*NOTE:* The `checkPhase` for python maps to the `installCheckPhase` on a
normal derivation. This is due to many python packages not behaving well
to the pre-installed version of the package. Version info, and natively
compiled extensions generally only exist in the install directory, and
thus can cause issues when a test suite asserts on that behavior.

*NOTE:* Tests should only be disabled if they don't agree with nix
(e.g. external dependencies, network access, flakey tests), however,
as many tests should be enabled as possible. Failing tests can still be
a good indication that the package is not in a valid state.

#### Using pytest

Pytest is the most common test runner for python repositories. A trivial
test run would be:
```
  checkInputs = [ pytest ];
  checkPhase = "pytest";
```

However, many repositories' test suites do not translate well to nix's build
sandbox, and will generally need many tests to be disabled.

To filter tests using pytest, one can do the following:
```
  checkInputs = [ pytest ];
  # avoid tests which need additional data or touch network
  checkPhase = ''
    pytest tests/ --ignore=tests/integration -k 'not download and not update'
  '';
```

`--ignore` will tell pytest to ignore that file or directory from being
collected as part of a test run. This is useful is a file uses a package
which is not available in nixpkgs, thus skipping that test file is much
easier than having to create a new package.

`-k` is used to define a predicate for test names. In this example, we are
filtering out tests which contain `download` or `update` in their test case name.
Only one `-k` argument is allows, and thus a long predicate should be concatenated
with "\" and wrapped to the next line.

*NOTE:* In pytest==6.0.1, the use of "\" to continue a line (e.g. `-k 'not download \'`) has
been removed, in this case, it's recommended to use `pytestCheckHook`.

#### Using pytestCheckHook

`pytestCheckHook` is a convenient hook which will substitute the setuptools
`test` command for a checkPhase which runs `pytest`. This is also beneficial
when a package may need many items disabled to run the test suite.

Using the example above, the analagous pytestCheckHook usage would be:
```
  checkInputs = [ pytestCheckHook ];

  # requires additional data
  pytestFlagsArray = [ "tests/" "--ignore=tests/integration" ];

  disabledTests = [
    # touches network
    "download"
    "update"
  ];
```

This is expecially useful when tests need to be conditionallydisabled,
for example:

```
  disabledTests = [
    # touches network
    "download"
    "update"
  ] ++ lib.optionals (pythonAtLeast "3.8") [
    # broken due to python3.8 async changes
    "async"
  ] ++ lib.optionals stdenv.isDarwin [
    # can fail when building with other packages
    "socket"
  ];
```
Trying to concatenate the related strings to disable tests in a regular checkPhase
would be much harder to read. This also enables us to comment on why specific tests
are disabled.

#### Using pythonImportsCheck

Although unit tests are highly prefered to valid correctness of a package. Not
all packages have test suites that can be ran easily, and some have none at all.
To help ensure the package still works, `pythonImportsCheck` can attempt to import
the listed modules.

```
  pythonImportsCheck = [ "requests" "urllib" ];
```
roughly translates to:
```
  postCheck = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
    python -c "import requests; import urllib"
  '';
```
However, this is done in it's own phase, and not dependent on whether `doCheck = true;`

This can also be useful in verifying that the package doesn't assume commonly
present packages (e.g. `setuptools`)

### Develop local package

As a Python developer you're likely aware of [development mode](http://setuptools.readthedocs.io/en/latest/setuptools.html#development-mode)
(`python setup.py develop`); instead of installing the package this command
creates a special link to the project code. That way, you can run updated code
without having to reinstall after each and every change you make. Development
mode is also available. Let's see how you can use it.

In the previous Nix expression the source was fetched from an url. We can also
refer to a local source instead using `src = ./path/to/source/tree;`

If we create a `shell.nix` file which calls `buildPythonPackage`, and if `src`
is a local source, and if the local source has a `setup.py`, then development
mode is activated.

In the following example we create a simple environment that has a Python 3.8
version of our package in it, as well as its dependencies and other packages we
like to have in the environment, all specified with `propagatedBuildInputs`.
Indeed, we can just add any package we like to have in our environment to
`propagatedBuildInputs`.

```nix
with import <nixpkgs> {};
with python38Packages;

buildPythonPackage rec {
  name = "mypackage";
  src = ./path/to/package/source;
  propagatedBuildInputs = [ pytest numpy pkgs.libsndfile ];
}
```

It is important to note that due to how development mode is implemented on Nix
it is not possible to have multiple packages simultaneously in development mode.

### Organising your packages

So far we discussed how you can use Python on Nix, and how you can develop with
it. We've looked at how you write expressions to package Python packages, and we
looked at how you can create environments in which specified packages are
available.

At some point you'll likely have multiple packages which you would
like to be able to use in different projects. In order to minimise unnecessary
duplication we now look at how you can maintain a repository with your
own packages. The important functions here are `import` and `callPackage`.

### Including a derivation using `callPackage`

Earlier we created a Python environment using `withPackages`, and included the
`toolz` package via a `let` expression.
Let's split the package definition from the environment definition.

We first create a function that builds `toolz` in `~/path/to/toolz/release.nix`

```nix
{ lib, buildPythonPackage }:

buildPythonPackage rec {
  pname = "toolz";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08fdd5ef7c96480ad11c12d472de21acd32359996f69a5259299b540feba4560";
  };

  meta = with lib; {
    homepage = "https://github.com/pytoolz/toolz/";
    description = "List processing tools and functional utilities";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
```

It takes an argument `buildPythonPackage`. We now call this function using
`callPackage` in the definition of our environment

```nix
with import <nixpkgs> {};

( let
    toolz = callPackage /path/to/toolz/release.nix {
      buildPythonPackage = python38Packages.buildPythonPackage;
    };
  in python38.withPackages (ps: [ ps.numpy toolz ])
).env
```

Important to remember is that the Python version for which the package is made
depends on the `python` derivation that is passed to `buildPythonPackage`. Nix
tries to automatically pass arguments when possible, which is why generally you
don't explicitly define which `python` derivation should be used. In the above
example we use `buildPythonPackage` that is part of the set `python38Packages`,
and in this case the `python38` interpreter is automatically used.

## Reference

### Interpreters

Versions 2.7, 3.6, 3.7 and 3.8 of the CPython interpreter are available as
respectively `python27`, `python36`, `python37` and `python38`. The
aliases `python2` and `python3` correspond to respectively `python27` and
`python38`. The default interpreter, `python`, maps to `python2`. The PyPy
interpreters compatible with Python 2.7 and 3 are available as `pypy27` and
`pypy3`, with aliases `pypy2` mapping to `pypy27` and `pypy` mapping to `pypy2`.
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
- `executable`. Name of the interpreter executable, e.g. `python3.8`.
- `pkgs`. Set of Python packages for that specific interpreter. The package set can be modified by overriding the interpreter and passing `packageOverrides`.

### Building packages and applications

Python libraries and applications that use `setuptools` or
`distutils` are typically built with respectively the `buildPythonPackage` and
`buildPythonApplication` functions. These two functions also support installing a `wheel`.

All Python packages reside in `pkgs/top-level/python-packages.nix` and all
applications elsewhere. In case a package is used as both a library and an
application, then the package should be in `pkgs/top-level/python-packages.nix`
since only those packages are made available for all interpreter versions. The
preferred location for library expressions is in
`pkgs/development/python-modules`. It is important that these packages are
called from `pkgs/top-level/python-packages.nix` and not elsewhere, to guarantee
the right version of the package is built.

Based on the packages defined in `pkgs/top-level/python-packages.nix` an
attribute set is created for each available Python interpreter. The available
sets are

* `pkgs.python27Packages`
* `pkgs.python36Packages`
* `pkgs.python37Packages`
* `pkgs.python38Packages`
* `pkgs.python39Packages`
* `pkgs.pypyPackages`

and the aliases

* `pkgs.python2Packages` pointing to `pkgs.python27Packages`
* `pkgs.python3Packages` pointing to `pkgs.python38Packages`
* `pkgs.pythonPackages` pointing to `pkgs.python2Packages`

#### `buildPythonPackage` function

The `buildPythonPackage` function is implemented in
`pkgs/development/interpreters/python/mk-python-derivation`
using setup hooks.

The following is an example:

```nix
{ lib, buildPythonPackage, fetchPypi, hypothesis, setuptools_scm, attrs, py, setuptools, six, pluggy }:

buildPythonPackage rec {
  pname = "pytest";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf8436dc59d8695346fcd3ab296de46425ecab00d64096cebe79fb51ecb2eb93";
  };

  postPatch = ''
    # don't test bash builtins
    rm testing/test_argcomplete.py
  '';

  checkInputs = [ hypothesis ];
  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ attrs py setuptools six pluggy ];

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar lovek323 madjar lsix ];
    description = "Framework for writing tests";
  };
}
```

The `buildPythonPackage` mainly does four things:

* In the `buildPhase`, it calls `${python.interpreter} setup.py bdist_wheel` to
  build a wheel binary zipfile.
* In the `installPhase`, it installs the wheel file using `pip install *.whl`.
* In the `postFixup` phase, the `wrapPythonPrograms` bash function is called to
  wrap all programs in the `$out/bin/*` directory to include `$PATH`
  environment variable and add dependent libraries to script's `sys.path`.
* In the `installCheck` phase, `${python.interpreter} setup.py test` is ran.

By default tests are run because `doCheck = true`. Test dependencies, like
e.g. the test runner, should be added to `checkInputs`.

By default `meta.platforms` is set to the same value
as the interpreter unless overridden otherwise.

##### `buildPythonPackage` parameters

All parameters from `stdenv.mkDerivation` function are still supported. The
following are specific to `buildPythonPackage`:

* `catchConflicts ? true`: If `true`, abort package build if a package name
  appears more than once in dependency tree. Default is `true`.
* `disabled` ? false: If `true`, package is not built for the particular Python
  interpreter version.
* `dontWrapPythonPrograms ? false`: Skip wrapping of Python programs.
* `permitUserSite ? false`: Skip setting the `PYTHONNOUSERSITE` environment
  variable in wrapped programs.
* `format ? "setuptools"`: Format of the source. Valid options are
  `"setuptools"`, `"pyproject"`, `"flit"`, `"wheel"`, and `"other"`.
  `"setuptools"` is for when the source has a `setup.py` and `setuptools` is
  used to build a wheel, `flit`, in case `flit` should be used to build a wheel,
  and `wheel` in case a wheel is provided. Use `other` when a custom
  `buildPhase` and/or `installPhase` is needed.
* `makeWrapperArgs ? []`: A list of strings. Arguments to be passed to
  `makeWrapper`, which wraps generated binaries. By default, the arguments to
  `makeWrapper` set `PATH` and `PYTHONPATH` environment variables before calling
  the binary. Additional arguments here can allow a developer to set environment
  variables which will be available when the binary is run. For example,
  `makeWrapperArgs = ["--set FOO BAR" "--set BAZ QUX"]`.
* `namePrefix`: Prepends text to `${name}` parameter. In case of libraries, this
  defaults to `"python3.8-"` for Python 3.8, etc., and in case of applications
  to `""`.
* `pipInstallFlags ? []`: A list of strings. Arguments to be passed to `pip
  install`. To pass options to `python setup.py install`, use
  `--install-option`. E.g., `pipInstallFlags=["--install-option='--cpp_implementation'"]`.
* `pythonPath ? []`: List of packages to be added into `$PYTHONPATH`. Packages
  in `pythonPath` are not propagated (contrary to `propagatedBuildInputs`).
* `preShellHook`: Hook to execute commands before `shellHook`.
* `postShellHook`: Hook to execute commands after `shellHook`.
* `removeBinByteCode ? true`: Remove bytecode from `/bin`. Bytecode is only
  created when the filenames end with `.py`.
* `setupPyGlobalFlags ? []`: List of flags passed to `setup.py` command.
* `setupPyBuildFlags ? []`: List of flags passed to `setup.py build_ext` command.

The `stdenv.mkDerivation` function accepts various parameters for describing
build inputs (see "Specifying dependencies"). The following are of special
interest for Python packages, either because these are primarily used, or
because their behaviour is different:

* `nativeBuildInputs ? []`: Build-time only dependencies. Typically executables
  as well as the items listed in `setup_requires`.
* `buildInputs ? []`: Build and/or run-time dependencies that need to be be
  compiled for the host machine. Typically non-Python libraries which are being
  linked.
* `checkInputs ? []`: Dependencies needed for running the `checkPhase`. These
  are added to `nativeBuildInputs` when `doCheck = true`. Items listed in
  `tests_require` go here.
* `propagatedBuildInputs ? []`: Aside from propagating dependencies,
  `buildPythonPackage` also injects code into and wraps executables with the
  paths included in this list. Items listed in `install_requires` go here.

##### Overriding Python packages

The `buildPythonPackage` function has a `overridePythonAttrs` method that can be
used to override the package. In the following example we create an environment
where we have the `blaze` package using an older version of `pandas`. We
override first the Python interpreter and pass `packageOverrides` which contains
the overrides for packages in the package set.

```nix
with import <nixpkgs> {};

(let
  python = let
    packageOverrides = self: super: {
      pandas = super.pandas.overridePythonAttrs(old: rec {
        version = "0.19.1";
        src =  super.fetchPypi {
          pname = "pandas";
          inherit version;
          sha256 = "08blshqj9zj1wyjhhw3kl2vas75vhhicvv72flvf1z3jvapgw295";
        };
      });
    };
  in pkgs.python3.override {inherit packageOverrides; self = python;};

in python.withPackages(ps: [ps.blaze])).env
```

#### `buildPythonApplication` function

The `buildPythonApplication` function is practically the same as
`buildPythonPackage`. The main purpose of this function is to build a Python
package where one is interested only in the executables, and not importable
modules. For that reason, when adding this package to a `python.buildEnv`, the
modules won't be made available.

Another difference is that `buildPythonPackage` by default prefixes the names of
the packages with the version of the interpreter. Because this is irrelevant for
applications, the prefix is omitted.

When packaging a Python application with `buildPythonApplication`, it should be
called with `callPackage` and passed `python` or `pythonPackages` (possibly
specifying an interpreter version), like this:

```nix
{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "luigi";
  version = "2.7.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "035w8gqql36zlan0xjrzz9j4lh9hs0qrsgnbyw07qs7lnkvbdv9x";
  };

  propagatedBuildInputs = with python3Packages; [ tornado_4 python-daemon ];

  meta = with lib; {
    ...
  };
}
```

This is then added to `all-packages.nix` just as any other application would be.

```nix
luigi = callPackage ../applications/networking/cluster/luigi { };
```

Since the package is an application, a consumer doesn't need to care about
Python versions or modules, which is why they don't go in `pythonPackages`.

#### `toPythonApplication` function

A distinction is made between applications and libraries, however, sometimes a
package is used as both. In this case the package is added as a library to
`python-packages.nix` and as an application to `all-packages.nix`. To reduce
duplication the `toPythonApplication` can be used to convert a library to an
application.

The Nix expression shall use `buildPythonPackage` and be called from
`python-packages.nix`. A reference shall be created from `all-packages.nix` to
the attribute in `python-packages.nix`, and the `toPythonApplication` shall be
applied to the reference:
```nix
youtube-dl = with pythonPackages; toPythonApplication youtube-dl;
```

#### `toPythonModule` function

In some cases, such as bindings, a package is created using
`stdenv.mkDerivation` and added as attribute in `all-packages.nix`. The Python
bindings should be made available from `python-packages.nix`. The
`toPythonModule` function takes a derivation and makes certain Python-specific
modifications.

```nix
opencv = toPythonModule (pkgs.opencv.override {
  enablePython = true;
  pythonPackages = self;
});
```

Do pay attention to passing in the right Python version!

#### `python.buildEnv` function

Python environments can be created using the low-level `pkgs.buildEnv` function.
This example shows how to create an environment that has the Pyramid Web Framework.
Saving the following as `default.nix`

```nix
with import <nixpkgs> {};

python.buildEnv.override {
  extraLibs = [ pythonPackages.pyramid ];
  ignoreCollisions = true;
}
```

and running `nix-build` will create

```
/nix/store/cf1xhjwzmdki7fasgr4kz6di72ykicl5-python-2.7.8-env
```

with wrapped binaries in `bin/`.

You can also use the `env` attribute to create local environments with needed
packages installed. This is somewhat comparable to `virtualenv`. For example,
running `nix-shell` with the following `shell.nix`

```nix
with import <nixpkgs> {};

(python3.buildEnv.override {
  extraLibs = with python3Packages; [ numpy requests ];
}).env
```

will drop you into a shell where Python will have the
specified packages in its path.


##### `python.buildEnv` arguments

* `extraLibs`: List of packages installed inside the environment.
* `postBuild`: Shell command executed after the build of environment.
* `ignoreCollisions`: Ignore file collisions inside the environment (default is `false`).
* `permitUserSite`: Skip setting the `PYTHONNOUSERSITE` environment variable in
  wrapped binaries in the environment.

#### `python.withPackages` function

The `python.withPackages` function provides a simpler interface to the `python.buildEnv` functionality.
It takes a function as an argument that is passed the set of python packages and returns the list
of the packages to be included in the environment. Using the `withPackages` function, the previous
example for the Pyramid Web Framework environment can be written like this:

```nix
with import <nixpkgs> {};

python.withPackages (ps: [ps.pyramid])
```

`withPackages` passes the correct package set for the specific interpreter
version as an argument to the function. In the above example, `ps` equals
`pythonPackages`. But you can also easily switch to using python3:

```nix
with import <nixpkgs> {};

python3.withPackages (ps: [ps.pyramid])
```

Now, `ps` is set to `python3Packages`, matching the version of the interpreter.

As `python.withPackages` simply uses `python.buildEnv` under the hood, it also
supports the `env` attribute. The `shell.nix` file from the previous section can
thus be also written like this:

```nix
with import <nixpkgs> {};

(python38.withPackages (ps: [ps.numpy ps.requests])).env
```

In contrast to `python.buildEnv`, `python.withPackages` does not support the
more advanced options such as `ignoreCollisions = true` or `postBuild`. If you
need them, you have to use `python.buildEnv`.

Python 2 namespace packages may provide `__init__.py` that collide. In that case
`python.buildEnv` should be used with `ignoreCollisions = true`.

#### Setup hooks

The following are setup hooks specifically for Python packages. Most of these
are used in `buildPythonPackage`.

- `eggUnpackhook` to move an egg to the correct folder so it can be installed
  with the `eggInstallHook`
- `eggBuildHook` to skip building for eggs.
- `eggInstallHook` to install eggs.
- `flitBuildHook` to build a wheel using `flit`.
- `pipBuildHook` to build a wheel using `pip` and PEP 517. Note a build system
  (e.g. `setuptools` or `flit`) should still be added as `nativeBuildInput`.
- `pipInstallHook` to install wheels.
- `pytestCheckHook` to run tests with `pytest`. See [example usage](#using-pytestcheckhook).
- `pythonCatchConflictsHook` to check whether a Python package is not already existing.
- `pythonImportsCheckHook` to check whether importing the listed modules works.
- `pythonRemoveBinBytecode` to remove bytecode from the `/bin` folder.
- `setuptoolsBuildHook` to build a wheel using `setuptools`.
- `setuptoolsCheckHook` to run tests with `python setup.py test`.
- `venvShellHook` to source a Python 3 `venv` at the `venvDir` location. A
  `venv` is created if it does not yet exist. `postVenvCreation` can be used to
  to run commands only after venv is first created.
- `wheelUnpackHook` to move a wheel to the correct folder so it can be installed
  with the `pipInstallHook`.

### Development mode

Development or editable mode is supported. To develop Python packages
`buildPythonPackage` has additional logic inside `shellPhase` to run `pip
install -e . --prefix $TMPDIR/`for the package.

Warning: `shellPhase` is executed only if `setup.py` exists.

Given a `default.nix`:
```nix
with import <nixpkgs> {};

pythonPackages.buildPythonPackage {
  name = "myproject";
  buildInputs = with pythonPackages; [ pyramid ];

  src = ./.;
}
```

Running `nix-shell` with no arguments should give you the environment in which
the package would be built with `nix-build`.

Shortcut to setup environments with C headers/libraries and Python packages:

```shell
nix-shell -p pythonPackages.pyramid zlib libjpeg git
```

Note: There is a boolean value `lib.inNixShell` set to `true` if nix-shell is invoked.

### Tools

Packages inside nixpkgs are written by hand. However many tools exist in
community to help save time. No tool is preferred at the moment.

- [pypi2nix](https://github.com/nix-community/pypi2nix): Generate Nix
  expressions for your Python project. Note that [sharing derivations from
  pypi2nix with nixpkgs is possible but not
  encouraged](https://github.com/nix-community/pypi2nix/issues/222#issuecomment-443497376).
- [python2nix](https://github.com/proger/python2nix) by Vladimir Kirillov.

### Deterministic builds

The Python interpreters are now built deterministically. Minor modifications had
to be made to the interpreters in order to generate deterministic bytecode. This
has security implications and is relevant for those using Python in a
`nix-shell`.

When the environment variable `DETERMINISTIC_BUILD` is set, all bytecode will
have timestamp 1. The `buildPythonPackage` function sets `DETERMINISTIC_BUILD=1`
and [PYTHONHASHSEED=0](https://docs.python.org/3.8/using/cmdline.html#envvar-PYTHONHASHSEED).
Both are also exported in `nix-shell`.

### Automatic tests

It is recommended to test packages as part of the build process.
Source distributions (`sdist`) often include test files, but not always.

By default the command `python setup.py test` is run as part of the
`checkPhase`, but often it is necessary to pass a custom `checkPhase`. An
example of such a situation is when `py.test` is used.

#### Common issues

* Non-working tests can often be deselected. By default `buildPythonPackage`
  runs `python setup.py test`. Most Python modules follows the standard test
  protocol where the pytest runner can be used instead. `py.test` supports a
  `-k` parameter to ignore test methods or classes:

  ```nix
  buildPythonPackage {
    # ...
    # assumes the tests are located in tests
    checkInputs = [ pytest ];
    checkPhase = ''
      py.test -k 'not function_name and not other_function' tests
    '';
  }
  ```
* Tests that attempt to access `$HOME` can be fixed by using the following
  work-around before running tests (e.g. `preCheck`): `export HOME=$(mktemp -d)`

## FAQ

### How to solve circular dependencies?

Consider the packages `A` and `B` that depend on each other. When packaging `B`,
a solution is to override package `A` not to depend on `B` as an input. The same
should also be done when packaging `A`.

### How to override a Python package?

We can override the interpreter and pass `packageOverrides`. In the following
example we rename the `pandas` package and build it.

```nix
with import <nixpkgs> {};

(let
  python = let
    packageOverrides = self: super: {
      pandas = super.pandas.overridePythonAttrs(old: {name="foo";});
    };
  in pkgs.python38.override {inherit packageOverrides;};

in python.withPackages(ps: [ps.pandas])).env
```

Using `nix-build` on this expression will build an environment that contains the
package `pandas` but with the new name `foo`.

All packages in the package set will use the renamed package. A typical use case
is to switch to another version of a certain package. For example, in the
Nixpkgs repository we have multiple versions of `django` and `scipy`. In the
following example we use a different version of `scipy` and create an
environment that uses it. All packages in the Python package set will now use
the updated `scipy` version.

```nix
with import <nixpkgs> {};

( let
    packageOverrides = self: super: {
      scipy = super.scipy_0_17;
    };
  in (pkgs.python38.override {inherit packageOverrides;}).withPackages (ps: [ps.blaze])
).env
```

The requested package `blaze` depends on `pandas` which itself depends on `scipy`.

If you want the whole of Nixpkgs to use your modifications, then you can use
`overlays` as explained in this manual. In the following example we build a
`inkscape` using a different version of `numpy`.

```nix
let
  pkgs = import <nixpkgs> {};
  newpkgs = import pkgs.path { overlays = [ (self: super: {
    python38 = let
      packageOverrides = python-self: python-super: {
        numpy = python-super.numpy_1_18;
      };
    in super.python38.override {inherit packageOverrides;};
  } ) ]; };
in newpkgs.inkscape
```

### `python setup.py bdist_wheel` cannot create .whl

Executing `python setup.py bdist_wheel` in a `nix-shell `fails with
```
ValueError: ZIP does not support timestamps before 1980
```

This is because files from the Nix store (which have a timestamp of the UNIX
epoch of January 1, 1970) are included in the .ZIP, but .ZIP archives follow the
DOS convention of counting timestamps from 1980.

The command `bdist_wheel` reads the `SOURCE_DATE_EPOCH` environment variable,
which `nix-shell` sets to 1. Unsetting this variable or giving it a value
corresponding to 1980 or later enables building wheels.

Use 1980 as timestamp:

```shell
nix-shell --run "SOURCE_DATE_EPOCH=315532800 python3 setup.py bdist_wheel"
```

or the current time:

```shell
nix-shell --run "SOURCE_DATE_EPOCH=$(date +%s) python3 setup.py bdist_wheel"
```

or unset `SOURCE_DATE_EPOCH`:

```shell
nix-shell --run "unset SOURCE_DATE_EPOCH; python3 setup.py bdist_wheel"
```

### `install_data` / `data_files` problems

If you get the following error:

```
could not create '/nix/store/6l1bvljpy8gazlsw2aw9skwwp4pmvyxw-python-2.7.8/etc':
Permission denied
```

This is a [known bug](https://github.com/pypa/setuptools/issues/130) in
`setuptools`. Setuptools `install_data` does not respect `--prefix`. An example
of such package using the feature is `pkgs/tools/X11/xpra/default.nix`.

As workaround install it as an extra `preInstall` step:

```shell
${python.interpreter} setup.py install_data --install-dir=$out --root=$out
sed -i '/ = data\_files/d' setup.py
```

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

### How to consume Python modules using pip in a virtual environment like I am used to on other Operating Systems?

While this approach is not very idiomatic from Nix perspective, it can still be
useful when dealing with pre-existing projects or in situations where it's not
feasible or desired to write derivations for all required dependencies.

This is an example of a `default.nix` for a `nix-shell`, which allows to consume
a virtual environment created by `venv`, and install Python modules through
`pip` the traditional way.

Create this `default.nix` file, together with a `requirements.txt` and simply
execute `nix-shell`.

```nix
with import <nixpkgs> { };

let
  pythonPackages = python3Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  venvDir = "./.venv";
  buildInputs = [
    # A Python interpreter including the 'venv' module is required to bootstrap
    # the environment.
    pythonPackages.python

    # This execute some shell code to initialize a venv in $venvDir before
    # dropping into the shell
    pythonPackages.venvShellHook

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    pythonPackages.numpy
    pythonPackages.requests

    # In this particular example, in order to compile any binary extensions they may
    # require, the Python modules listed in the hypothetical requirements.txt need
    # the following packages to be installed locally:
    taglib
    openssl
    git
    libxml2
    libxslt
    libzip
    zlib
  ];

  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    unset SOURCE_DATE_EPOCH
    pip install -r requirements.txt
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook = ''
    # allow pip to install wheels
    unset SOURCE_DATE_EPOCH
  '';

}
```

In case the supplied venvShellHook is insufficient, or when Python 2 support is
needed, you can define your own shell hook and adapt to your needs like in the
following example:

```nix
with import <nixpkgs> { };

let
  venvDir = "./.venv";
  pythonPackages = python3Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  buildInputs = [
    pythonPackages.python
    # Needed when using python 2.7
    # pythonPackages.virtualenv
    # ...
  ];

  # This is very close to how venvShellHook is implemented, but
  # adapted to use 'virtualenv'
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)

    if [ -d "${venvDir}" ]; then
      echo "Skipping venv creation, '${venvDir}' already exists"
    else
      echo "Creating new venv environment in path: '${venvDir}'"
      # Note that the module venv was only introduced in python 3, so for 2.7
      # this needs to be replaced with a call to virtualenv
      ${pythonPackages.python.interpreter} -m venv "${venvDir}"
    fi

    # Under some circumstances it might be necessary to add your virtual
    # environment to PYTHONPATH, which you can do here too;
    # PYTHONPATH=$PWD/${venvDir}/${pythonPackages.python.sitePackages}/:$PYTHONPATH

    source "${venvDir}/bin/activate"

    # As in the previous example, this is optional.
    pip install -r requirements.txt
  '';
}
```

Note that the `pip install` is an imperative action. So every time `nix-shell`
is executed it will attempt to download the Python modules listed in
requirements.txt. However these will be cached locally within the `virtualenv`
folder and not downloaded again.

### How to override a Python package from `configuration.nix`?

If you need to change a package's attribute(s) from `configuration.nix` you could do:

```nix
  nixpkgs.config.packageOverrides = super: {
    python = super.python.override {
      packageOverrides = python-self: python-super: {
        zerobin = python-super.zerobin.overrideAttrs (oldAttrs: {
          src = super.fetchgit {
            url = "https://github.com/sametmax/0bin";
            rev = "a344dbb18fe7a855d0742b9a1cede7ce423b34ec";
            sha256 = "16d769kmnrpbdr0ph0whyf4yff5df6zi4kmwx7sz1d3r6c8p6xji";
          };
        });
      };
    };
  };
```

`pythonPackages.zerobin` is now globally overridden. All packages and also the
`zerobin` NixOS service use the new definition. Note that `python-super` refers
to the old package set and `python-self` to the new, overridden version.

To modify only a Python package set instead of a whole Python derivation, use
this snippet:

```nix
  myPythonPackages = pythonPackages.override {
    overrides = self: super: {
      zerobin = ...;
    };
  }
```

### How to override a Python package using overlays?

Use the following overlay template:

```nix
self: super: {
  python = super.python.override {
    packageOverrides = python-self: python-super: {
      zerobin = python-super.zerobin.overrideAttrs (oldAttrs: {
        src = super.fetchgit {
          url = "https://github.com/sametmax/0bin";
          rev = "a344dbb18fe7a855d0742b9a1cede7ce423b34ec";
          sha256 = "16d769kmnrpbdr0ph0whyf4yff5df6zi4kmwx7sz1d3r6c8p6xji";
        };
      });
    };
  };
}
```

### How to use Intel's MKL with numpy and scipy?

MKL can be configured using an overlay. See the section "[Using overlays to
configure alternatives](#sec-overlays-alternatives-blas-lapack)".

### What inputs do `setup_requires`, `install_requires` and `tests_require` map to?

In a `setup.py` or `setup.cfg` it is common to declare dependencies:

* `setup_requires` corresponds to `nativeBuildInputs`
* `install_requires` corresponds to `propagatedBuildInputs`
* `tests_require` corresponds to `checkInputs`

## Contributing

### Contributing guidelines

Following rules are desired to be respected:

* Python libraries are called from `python-packages.nix` and packaged with
  `buildPythonPackage`. The expression of a library should be in
  `pkgs/development/python-modules/<name>/default.nix`. Libraries in
  `pkgs/top-level/python-packages.nix` are sorted quasi-alphabetically to avoid
  merge conflicts.
* Python applications live outside of `python-packages.nix` and are packaged
  with `buildPythonApplication`.
* Make sure libraries build for all Python interpreters.
* By default we enable tests. Make sure the tests are found and, in the case of
  libraries, are passing for all interpreters. If certain tests fail they can be
  disabled individually. Try to avoid disabling the tests altogether. In any
  case, when you disable tests, leave a comment explaining why.
* Commit names of Python libraries should reflect that they are Python
  libraries, so write for example `pythonPackages.numpy: 1.11 -> 1.12`.
* Attribute names in `python-packages.nix` should be normalized according to
  [PEP 0503](https://www.python.org/dev/peps/pep-0503/#normalized-names). This
  means that characters should be converted to lowercase and `.` and `_` should
  be replaced by a single `-` (foo-bar-baz instead of Foo__Bar.baz )
