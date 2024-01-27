# Platform Support {#chap-platform-support}

Packages receive varying degrees of support, both in terms of maintainer attention and available computation resources for continuous integration (CI).

Below is the list of the best supported platforms:

- `x86_64-linux`: Highest level of support.
- `aarch64-linux`: Well supported, with most packages building successfully in CI.
- `aarch64-darwin`: Receives better support than `x86_64-darwin`.
- `x86_64-darwin`: Receives some support.

There are many other platforms with varying levels of support.
The provisional platform list in [Appendix A] of [RFC046], while not up to date, can be used as guidance.

A more formal definition of the platform support tiers is provided in [RFC046], but has not been fully implemented yet.

[RFC046]: https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md
[Appendix A]: https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md#appendix-a-non-normative-description-of-platforms-in-november-2019
