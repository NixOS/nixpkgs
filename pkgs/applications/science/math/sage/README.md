# Sage on nixos

Sage is a pretty complex package that depends on many other complex packages and patches some of those. As a result, the sage nix package is also quite complex.

Don't feel discouraged to fix, simplify or improve things though. The individual files have comments explaining their purpose. The most importent ones are `default.nix` linking everything together, `sage-src.nix` adding patches and `sagelib.nix` building the actual sage package.

## The sage build is broken

First you should find out which change to nixpkgs is at fault (if you don't already know). You can use `git-bisect` for that (see the manpage).

If the build broke as a result of a package update, try those solutions in order:

- search the [sage trac](https://trac.sagemath.org/) for keywords like "Upgrade <package>". Maybe somebody has already proposed a patch that fixes the issue. You can then add a `fetchpatch` to `sage-src.nix`.

- check if [gentoo](https://github.com/cschwan/sage-on-gentoo/tree/master/sci-mathematics/sage), [debian](https://salsa.debian.org/science-team/sagemath/tree/master/debian) or [arch linux](https://git.archlinux.org/svntogit/community.git/tree/trunk?h=packages/sagemath) already solved the problem. You can then again add a `fetchpatch` to `sage-src.nix`. If applicable you should also [propose the patch upstream](#proposing-a-sage-patch).

- fix the problem yourself. First clone the sagemath source and then check out the sage version you want to patch:

```
[user@localhost ~]$ git clone https://github.com/sagemath/sage.git
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
[user@localhost ~]$ git clone https://github.com/sagemath/sage.git
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
