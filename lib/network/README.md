# Network library

This is the internal contributor documentation.

## Goals

The main goal of the network library is to provide utility functions for IPv4 and IPv6 conversions.
It should have the following properties.

- Easy: The functions should have obvious semantics.
- Safe: Throw early and helpful errors when mistakes are detected.
- Lazy: Only compute values when necessary.

## Tests

Tests are declared in `tests.sh`.

## Other implementations and references

- [Haskell](https://hackage.haskell.org/package/ip)
- [Python](https://docs.python.org/3/library/ipaddress.html)
- [Rust](https://doc.rust-lang.org/std/net/enum.IpAddr.html)
