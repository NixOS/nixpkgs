---
name: Out-of-date package reports
about: For packages that are out-of-date
title: ''
labels: '9.needs: package (update)'
assignees: ''

---


###### Checklist

<!-- Note that these are hard requirements -->

<!--
You can use the "Go to file" functionality on GitHub to find the package
Then you can go to the history for this package
Find the latest "package_name: old_version -> new_version" commit
The "new_version" is the current version of the package
-->
- [ ] Checked the [nixpkgs master branch](https://github.com/NixOS/nixpkgs)
<!--
Type the name of your package and try to find an open pull request for the package
If you find an open pull request, you can review it!
There's a high chance that you'll have the new version right away while helping the community!
-->
- [ ] Checked the [nixpkgs pull requests](https://github.com/NixOS/nixpkgs/pulls)

###### Project name
`nix search` name:
<!--
The current version can be found easily with the same process as above for checking the master branch
If an open PR is present for the package, take this version as the current one and link to the PR
-->
current version:
desired version:

###### Notify maintainers
<!--
Search your package here: https://search.nixos.org/packages?channel=unstable
If no maintainer is listed for your package, tag the person that last updated the package
-->

maintainers:

###### Note for maintainers

Please tag this issue in your PR.
