# Network library

## General

This document explains why the `lib.network` library is designed the way it is.

This library is intended mainly for working with IP addresses, finding derived
information. The library is divided into IPv4 and IPv6. There are two types
that can be used in modules: `ipv4Addr`, `ipv6Addr` that can be used in modules:
`ipv4Addr`, `ipv6Addr`. Each type represent a string that is a valid ip address.

To use types in a module system, use `mkNetworkingOption` with `type = 4`
or `type = 6`. Internally, it converts the supplied string version of an IP
address to a parsed version using the `lib.ipv${version}.fromString` function.
The returned `ipv4AddrAttrs` or `ipv6AddrAttrs` contains different versions
of the parsed IP address strings and the internal representation of the parsed
addresses. So other functions from the network library can easily use the IP
address without re-parsing.

Structure of `ipv${version}AddrAttr`:
* `address`: a string representation of an IP address without prefix length. Example: `"2001:0000:130f:0000:0000:09c0:876a:130b"`.
  See [String representation].
* `addressCidr`: a string representation of an IP address with prefix length. Example: `"2001:0000:130f:0000:0000:09c0:876a:130b/64"`.
* `url`: a string representation used in URL's syntax. Example: `"[2001:0000:130f:0000:0000:09c0:876a:130b]"`.
* `urlWithPort`: a function that consumes port and appends port to the url representation. Example: `"[2001:0000:130f:0000:0000:09c0:876a:130b]:80"`.
* `prefixLength`: subnet size. Example: 64.
* `_address`: an internal representation of an IP address, which is used by network functions. Example: `[8193 0 4879 0 0 2496 34666 4875]`
  See [Internal representation].

## Design

### IP Parser
[IP Parser]: #ip-parser

IP addresses do not have a single unified representation. There is a "default"
IP address such as `192.168.0.1` or CIDR notation `192.168.0.1/32`. IPv6
addresses have even more different variations and compressions. In order not
to complicate the life of the end user, the network library provides only two
functions `fromString` (one for ipv4 and one for ipv6) that analyzes the various
parameters and determines by itself what the current structure is. For example,
if the IP address contains the prefix length character "/", then the function
will parse the address in CIDR notation. If the prefix length is missing, the
default length will be set.

Note: Currently IPv6 parser doesn't support an alternative form that is
sometimes more convenient when dealing with a mixed environment of IPv4 and IPv6
nodes is `x:x:x:x:x:x:d.d.d.d` defined in [IP Version 6 Addressing Architecture RFC 4291][RFC 4291].

[RFC 4291]: https://datatracker.ietf.org/doc/html/rfc4291#section-2.2

### Internal representation
[Internal representation]: #internal-representation

End users want to work with IP addresses as strings most of the time. But
strings are not easy to work with. Internal functions are much more comfortable
working with a list of integers that can only be parsed once, then worked with
and stored hidden. You can easily convert such data backto a string.
See [String representation]. In the code, every time you see `ipv6IR` - it means
that it is an internal representation / list of integers.

### String representation
[String representation]: #string-representation

For IPv4, everything is simple - join all octets with a colon and add prefix
length for `addressCidr`.

For IPv6, everything is much more complicated. It can be presented in different
 ways: lowercase or uppercase, with compression or without, etc. Read the
[A Recommendation for IPv6 Address Text Representation RFC 5952][RFC 5952] to
 understand the problem.

Since in most cases IP addresses are used in configurations, there is no point
in doing compression. After all operations, the address that can be written `::`
will look like `0:0:0:0:0:0:0:0`. This greatly simplifies the library.

[RFC 5952]: https://datatracker.ietf.org/doc/html/rfc5952

## Other implementations and references

- [Rust](https://doc.rust-lang.org/std/net/enum.IpAddr.html)
