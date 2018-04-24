# Sage on nixos

Sage is a pretty complex package that depends on many other complex packages and patches some of those. As a result, the sage nix package is also quite complex.

Don't feel discouraged to fix, simplify or improve things though. Here's a quick overview over the functions of the individual files:

- `sage-src.nix`  
  Downloads the source code and applies patches. This makes sure that all the other files work with the same sage source. If you want to apply a patch to sage or update sage to a new version, this is the place to do it.

- `env-locations.nix`  
  Creates a bash file that sets a bunch of environment variables telling sage where to find various packages and files. The definitions of those environment variables can be found in the sage source in the `src/env.py` file. This bash file needs to be sourced before sage is started (done in `sage-env.nix` and `sagedoc.nix`).

- `sage-env.nix`  
  Sets all environment variables sage needs to run. This includes the package locations defined in `env-locations.nix` as well as the location of sage itself and its various subdirectories.

- `sagelib.nix`  
  Defines the main sage package (without setting the necessary environments or running any tests).

- `sage-with-env.nix`  
  Wraps sage in the necessary environment.

- `sage.nix`  
  Runs sages doctests.

- `sage-wrapper.nix`  
  Optionally tells sage where do find the docs.

- `sagedoc.nix`  
  Builds and tests the sage html documentation. Can be used for offline documentation viewing as well as the sage `browse_sage_doc` and `search_doc` functions.

- `sagenb.nix`  
  The (semi deprecated) sage notebook.

- `default.nix`  
  Introduces necessary overrides, defines new packages and ties everything together (returning the `sage` package).

- `flask-oldsessions.nix`, `flask-openid.nix`, `python-openid.nix`
  These are python packages that were rejected from the main nixpkgs tree because they appear unmaintained. They are needed for the (semi-deprecated) sage notebook. Since that notebook is still needed to run the sage doctests, these packages are included but not exposed to the rest of nixpkgs.

- `pybrial.nix`  
  pybrial is a dependency of sage. However, pybrial itself also has sage as a dependency. Because of that circular dependency, pybrial is hidden from the rest of nixpkgs (just as the flask packages and python-openid.

- `openblas-pc.nix`  
  This creates a `.pc` file to be read by `pkg-config` that allows openblas to take on different roles, like `cblas` or `lapack`.

## The sage build is broken

First you should find out which change to nixpkgs is at fault (if you don't already know). You can use `git-bisect` for that (see the manpage).

If the build broke as a result of a package update, try those solutions in order:

- search the [sage trac](https://trac.sagemath.org/) for keywords like "Upgrade <package>". Maybe somebody has already proposed a patch that fixes the issue. You can then add a `fetchpatch` to `sage-src.nix`.

- check if [gentoo](https://github.com/cschwan/sage-on-gentoo/tree/master/sci-mathematics/sage), [debian](https://salsa.debian.org/science-team/sagemath/tree/master/debian) or [arch linux](https://git.archlinux.org/svntogit/community.git/tree/trunk?h=packages/sagemath) already solved the problem. You can then again add a `fetchpatch` to `sage-src.nix`. If applicable you should also [propose the patch upstream](#proposing-a-sage-patch).

- fix the problem yourself. First clone the sagemath source and then check out the sage version you want to patch:

```
[user@localhost ~]$ git clone git://github.com/sagemath/sage.git
[user@localhost ~]$ cd sage
[user@localhost sage]$ git checkout 8.2 # substitute the relevant version here
```

Then make the needed changes and generate a patch with `git diff`:

```
[user@localhost ~]$ <make changes>
[user@localhost ~]$ git diff -u > /path/to/nixpkgs/pkgs/applications/science/math/sage/patches/name-of-patch.patch
```

Now just add the patch to `sage-src.nix` and test your changes. If they fix the problem, [propose them upstream](#proposing-a-sage-patch) and add a link to the trac ticket.

- pin the package version in `default.nix` and add a note that explains why that is necessary.


## Proposing a sage patch

You can [login the sage trac using GitHub](https://trac.sagemath.org/login). Your username will then be `gh-<your-github-name>`. The only other way is to request a trac account via email. After that refer to [git the hard way](http://doc.sagemath.org/html/en/developer/manual_git.html#chapter-manual-git) in the sage documentation. The "easy way" requires a non-GitHub account (requested via email) and a special tool. The "hard way" is really not all that hard if you're a bit familiar with git.

Here's the gist, assuming you want to use ssh key authentication. First, [add your public ssh key](https://trac.sagemath.org/prefs/sshkeys). Then:

```
[user@localhost ~]$ git clone git://github.com/sagemath/sage.git
[user@localhost ~]$ cd sage
[user@localhost sage]$ git remote add trac git@trac.sagemath.org:sage.git -t master
[user@localhost sage]$ git checkout -b u/gh-<your-github-username>/<your-branch-name> develop
[user@localhost sage]$ <make changes>
[user@localhost sage]$ git add .
[user@localhost sage]$ git commit
[user@localhost sage]$ git show # review your changes
[user@localhost sage]$ git push --set-upstream trac u/gh-<your-github-username>/<your-branch-name>
```

You now created a branch on the trac server (you *must* follow the naming scheme as you only have push access to branches with the `u/gh-<your-github-username>/` prefix).
Now you can [create a new trac ticket](https://trac.sagemath.org/newticket).
- Write a description of the change
- set the type and component as appropriate
- write your real name in the "Authors" field
- write `u/gh-<your-github-username>/<your-branch-name>` in the "Branch" field
- click "Create ticket"
- click "Modify" on the top right of your ticket (for some reason you can only change the ticket status after you have created it)
- set the ticket status from `new` to `needs_review`
- click "Save changes"

Refer to sages [Developer's Guide](http://doc.sagemath.org/html/en/developer/index.html) for further details.

## I want to update sage

You'll need to change the `version` field in `sage-src.nix`. Afterwards just try to build and let nix tell you which patches no longer apply (hopefully because they were adopted upstream). Remove those.

Hopefully the build will succeed now. If it doesn't and the problem is obvious, fix it as described in [The sage build is broken](#the-sage-build-is-broken).
If the problem is not obvious, you can try to first update sage to an intermediate version (remember that you can also set the `version` field to any git revision of sage) and locate the sage commit that introduced the issue. You can even use `git-bisect` for that (it will only be a bit tricky to keep track of which patches to apply). Hopefully after that the issue will be obvious.

## Well, that didn't help!

If you couldn't fix the problem, create a GitHub issue on the nixpkgs repo and ping @timokau (or whoever is listed in the `maintainers` list of the sage package).
Describe what you did and why it didn't work. Afterwards it would be great if you help the next guy out and improve this documentation!
