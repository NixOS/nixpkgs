# State management in NixOS

- see also latest version of this document (if you come from discourse): https://github.com/bendlas/nixpkgs/blob/nixos-state-management/nixos/state/requirements.md
- see also PR: https://github.com/NixOS/nixpkgs/pull/267365
- see also Discourse: https://discourse.nixos.org/t/what-about-state-management/37082

## Motivating use cases

There are various cases for the deployment descriptor to talk about
the state of one of its instances at a given point in time:

### Instance wants to move along with environment updates
e.g.
- Schema update for new database version
- Restore state from backup location
- Apply novelty in dependency order
- Generate secrets for new services

### Update process wants to predict how new version will apply to current state
e.g.
- database folder version <= database service version
- username <-> uid assignment in new version matches /etc/passwd
- running kernel supports required features (in case of switch)

### Update process wants to offer resolution steps in case of errors and warnings
e.g.
- data format from compatibility check
- with executable resolution steps
- consumed by updater UI (revamped `nixos-rebuild boot/switch`)
- reboot requirement detection + scheduling

### Bringing Nix to state management

As @grahamc aptly noted in a [conversation about `ensure*` - style
options](https://github.com/NixOS/nixpkgs/issues/206467#issuecomment-1355889925):

```
ensure smacks of convergent configuration management. NixOS is special because it describes what is.
```

So we want to take a close look at what we can do to keep the magic sprinkles, while getting into the thick of it.

## Requirements

Approaching actual technical requirements, let's first acknowledge the
magnitude of the problem:

We're aiming to provide a state-management mechanism, that's general
enough to be used in most (any?) dependency graph of stateful
services, while being concrete and convenient enough to be actually
useful when implementing or integrating given graph.

So before going through the requirement analysis, feel free to skip
ahead to [Key Insights], before continuing here.

We want NixOS to:
- predict whether an update will succeed
  - make it straightforward for module authors to implement corresponding checks
  - run a system-check phase, before a system switch
  - generate applicable choices alongside prediction
- present available migration choices to user, before or after a system switch
  - could be interactive
  - could be process driven
  - interactivity should be asynchronous in nature, system should have
    no problem waiting for a choice across a reboot.
- execute given choices, tracking progress
  - span reboots
  - progress independent steps in parallel
  - expect and recover from failure
  - possibility to generate new migration choices during execution
    progress, in case of unexpected results

## Implementation plan

We'll start by building a proper harness for the two existing steps -
`set-system-symlink` and `switch-to-configuration` - with
consideration for the requirements:

We propose a simple 2-phase model of:
- `read-current-state` returning
  - error-, warning-, recommendation-items
  - applicable resolution - migration steps per item
- `apply-migrations` to be called in dependency order, with selected
  steps

Where each step can declare two corresponding programs, producing and
consuming items, interacting with the system as per-step configurable user.

Once a dependency graph of migration steps has been committed and
entered, the system can only move along defined edges, before becoming
usable again. If an unexpected condition inserts edges or invalidates
previously made choices, this should also be explicit.

### and from there

the community can step in and build on a commong interface

- declare open season on `stc`
- library for common uses
  - database creation & permission
  - `/var/lib` juggling
  - fleet management?

## Key Insights

### Atomic reference semantics

NixOS provices atomic / compare-and-set (CAS) semantics for the whole
system. This is what makes it fun to hack on.

Unfortunately, the closest we can get to CAS with e.g. database state
is backups / snapshots. With this, even a single state assertion of
sufficient size could take hours.

### `switch-to-configuration.pl` is reentrant

Before figuring out where to fit state management into NixOS, let's
look at the one instance where NixOS already manages state, and very
successfully so:

`switch-to-configuration.pl` (`stc`) is NixOS' ultimate state
transition. `stc` is what happens, when running `nixos-rebuild switch/boot`
(henceforth `switch-boot`), and (roughly, possibly deferreed with
`boot`) updates `/etc` and lets systemd reload the service graph.

The perspective of unraveling `stc` may seem daunting, but for the
fact that there is already a split point implemented:

### `nixos-rebuild switch/boot` is not actually atomic

There is a step before `stc`, that updates the system symlink:

```sh
nix-env --profile /nix/var/nix/profiles/system --set $configuration
$configuration/bin/switch-to-configuration $action
```

This makes `switch-boot` an ideal location to consider for an
extension point.  Instead of creating ad-hoc points of convergence
(ensure options), we can use the existing one, and make it more robust
at the same time.

Consider, how monad stacks also tend to bottom out at IO.

What could be done from `switch-boot` (e.g.)?
- blocking system updates on detected incompatibilities
- produce applicable state transitions for resolutions and recommendations
- interactively guide the user through resolution choices for
  individual service migrations
  - or confirm actions before they are applied
 
### `nixos-install` could just be a different set of state changes, implemented by a core module
- let user set root password
- initialize boot loader / firmware

### State management by reinforcing and generalizing the existing one (reifying)

If configuration could add steps to `switch-boot` - in addition to the
already possible service graph modifications (`systemd.*`) - modules
could implement their own activation checks and actions.

The tricky part is to get the interface right, because any correct
take probably involves various sorts of complex data structures,
including decision trees and asynchronous channels.

Additionally, `boot` vs `switch` needs to be accomodated in any
abstraction. On a closer look, this only really confirms the
requirement for reifying resolution - transitions as well.
