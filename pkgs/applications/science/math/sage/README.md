# Sage on nixos

Sage is a pretty complex package that depends on many other complex packages and patches some of those. As a result, the sage nix package is also quite complex.

Don't feel discouraged to fix, simplify or improve things though. The individual files have comments explaining their purpose. The most importent ones are `default.nix` linking everything together, `sage-src.nix` adding patches and `sagelib.nix` building the actual sage package.

## The sage build is broken

First you should find out which change to nixpkgs is at fault (if you don't already know). You can use `git-bisect` for that (see the manpage).

If the build broke as a result of a package update, try those solutions in order:

- search the [sage GitHub repo](https://github.com/sagemath/sage) for keywords like "Upgrade <package>". Maybe somebody has already proposed a patch that fixes the issue. You can then add a `fetchpatch` to `sage-src.nix`.

- check if [gentoo](https://github.com/cschwan/sage-on-gentoo/tree/master/sci-mathematics/sage), [debian](https://salsa.debian.org/science-team/sagemath/tree/master/debian) or [arch linux](https://git.archlinux.org/svntogit/community.git/tree/trunk?h=packages/sagemath) already solved the problem. You can then again add a `fetchpatch` to `sage-src.nix`. If applicable you should also [propose the patch upstream](#proposing-a-sage-patch).

- fix the problem yourself. First clone the sagemath source and then check out the sage version you want to patch:

```
[user@localhost ~]$ git clone https://github.com/sagemath/sage.git
[user@localhost ~]$ cd sage
[user@localhost sage]$ git checkout 9.8 # substitute the relevant version here
```

Then make the needed changes and generate a patch with `git diff`:

```
[user@localhost ~]$ <make changes>
[user@localhost ~]$ git diff -u > /path/to/nixpkgs/pkgs/applications/science/math/sage/patches/name-of-patch.patch
```

Now just add the patch to `sage-src.nix` and test your changes. If they fix the problem, submit a PR upstream (refer to sages [Developer's Guide](http://doc.sagemath.org/html/en/developer/index.html) for further details).

- pin the package version in `default.nix` and add a note that explains why that is necessary.

## I want to update sage

You'll need to change the `version` field in `sage-src.nix`. Afterwards just try to build and let nix tell you which patches no longer apply (hopefully because they were adopted upstream). Remove those.

Hopefully the build will succeed now. If it doesn't and the problem is obvious, fix it as described in [The sage build is broken](#the-sage-build-is-broken).
If the problem is not obvious, you can try to first update sage to an intermediate version (remember that you can also set the `version` field to any git revision of sage) and locate the sage commit that introduced the issue. You can even use `git-bisect` for that (it will only be a bit tricky to keep track of which patches to apply). Hopefully after that the issue will be obvious.

## Well, that didn't help!

If you couldn't fix the problem, create a GitHub issue on the nixpkgs repo and ping the sage maintainers (as listed in the sage package).
Describe what you did and why it didn't work. Afterwards it would be great if you help the next guy out and improve this documentation!
