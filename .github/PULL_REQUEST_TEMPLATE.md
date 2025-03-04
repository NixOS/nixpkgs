
<!--
^ Please summarise the changes you have done and explain why they are necessary above ^

For package updates, please link to a changelog or describe the upstream changes yourself. This helps your fellow maintainers discover breaking changes which they need to look out for.
For new packages, please briefly describe what the package is and why it should be added to Nixpkgs (i.e. because it's a popular, new, handy tool). Ideally also provide a link to its homepage.

The following sections are entirely *optional* but most of the information that it asks you to provide will have to be enquired in any case (https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#the-committers-perspective). Filling this out at least a little bit goes a long way towards speeding up the review process, so please try to write as much as you think is reasonable.
-->

## What was tested

<!--
Us Nixpkgs maintainers need confidence that your change is good and doesn't break anything unexpectedly. If you have done testing on your changes to verify that they work as intended, please tell us about it. This helps us gain confidence in the quality of your PR which greatly helps to speed up the review process.

I.e. that you have executed the [NixOS test(s)](https://nixos.org/manual/nixos/unstable/index.html#sec-nixos-tests) (look inside [nixos/tests](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests)) and/or [package tests](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#package-tests).

Or, for functions and "core" functionality, the tests in [lib/tests](https://github.com/NixOS/nixpkgs/blob/master/lib/tests) or [pkgs/test](https://github.com/NixOS/nixpkgs/blob/master/pkgs/test)

Also make sure NixOS tests are [linked](https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#linking-nixos-module-tests-to-a-package) to the relevant packages so that automated tools can find, execute and report them.

(You don't need to write prose, bullet points are sufficient.)
-->

- [ ] Tested basic functionality of all binary files (usually in `./result/bin/`)
- [ ] Tested compilation of all packages that depend on this change using `nix-shell -p nixpkgs-review --run "nixpkgs-review rev HEAD"`. Note: all changes have to be committed, also see [nixpkgs-review usage](https://github.com/Mic92/nixpkgs-review#usage)
- [x] I have not tested these changes <!-- Please describe your testing! -->

<!--
Invite other users of the component(s) you changed to review your PR by [@-mentioning](https://github.blog/news-insights/mention-somebody-they-re-notified/) them or requesting a review if they're part of the NixOS Github organisation.
When other users of the component test your PR and find it to work as expected, it greatly helps reviewers to gain confidence in the quality of your changes.
-->



If you actively use the component(s) changed in this PR, please test the component(s) built from this PR and report your findings. It really helps a lot.

## How can reviewers test this PR?

<!--
In order for your PR to be merged, it must be reviewed by someone else. To increase the number of people who are able to review your PR, please provide simple and easy to execute steps that reviewers can follow to convince themselves that your changes work as intended. These should be easy to execute and should not require any significant setup process that a potential reviewer would have to work out themselves or domain knowlegde of the component on their part. Someone totally unfamiliar with the component(s) should be able to follow the steps in at maximum a few minutes without needing to do any research.

Ideally, you should provide detailed reproduction steps as if you were reporting a bug; see it as reporting a feature ;)

See also [the contributor's guide](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#how-to-help-committers-assess-your-pr).

Examples:

- "Run the `hello` binary and check whether it greets the world in the terminal output."
- "Open the desktop application, open an image file in it via the `File` menu and apply the xyz filter to it. It should look all xyz'd up and not crash anymore."
- "`nixos-rebuild build-vm` using the following NixOS config (...) and then open localhost:1234 in a browser. You should see a fancy dashboard and no red warning messages."
-->



If you are a user and have a simple setup for the component(s) changed by this PR which others could use to test this PR, please reply and share it with us.

## Things done

<!-- Please check what applies. Note that these are not hard requirements but merely serve as information for reviewers that is easy to consume at a glance. -->

- Built on platform(s)
  - [ ] x86_64-linux
  - [ ] aarch64-linux
  - [ ] x86_64-darwin
  - [ ] aarch64-darwin
- For non-Linux: Is sandboxing enabled in `nix.conf`? (See [Nix manual](https://nixos.org/manual/nix/stable/command-ref/conf-file.html))
  - [ ] `sandbox = relaxed`
  - [ ] `sandbox = true`
- [25.05 Release Notes](https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/release-notes/rl-2505.section.md) (or backporting [24.11](https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/release-notes/rl-2411.section.md) and [25.05](https://github.com/NixOS/nixpkgs/blob/master/nixos/doc/manual/release-notes/rl-2505.section.md) Release notes)
  - [ ] (Package updates) Added a release notes entry if the change is major or breaking
  - [ ] (Module updates) Added a release notes entry if the change is significant
  - [ ] (Module addition) Added a release notes entry if adding a new NixOS module
- [ ] Fits [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md).

<!--
To help with the large amounts of pull requests, we would appreciate your
reviews of other pull requests, especially simple package updates. Just leave a
comment describing what you have tested in the relevant package/service.
Reviewing helps to reduce the average time-to-merge for everyone.
Thanks a lot if you do!

List of open PRs: https://github.com/NixOS/nixpkgs/pulls
Reviewing guidelines: https://github.com/NixOS/nixpkgs/blob/master/pkgs/README.md#reviewing-contributions
-->

---

Add a :+1: [reaction] to [pull requests you find important].

[reaction]: https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[pull requests you find important]: https://github.com/NixOS/nixpkgs/pulls?q=is%3Aopen+sort%3Areactions-%2B1-desc
