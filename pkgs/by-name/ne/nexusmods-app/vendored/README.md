This directory contains a vendored copy of `games.json`, along with tooling to generate it.

## Purpose

The games data is fetched at runtime by NexusMods.App, however it is also included at build time for two reasons:

1. It allows tests to run against real data.
2. It is used as cached data, speeding up the app's initial run.

It is not vital for the file to contain all games, however ideally it should contain all games _supported_ by this version of NexusMods.App.
That way the initial run's cached data is more useful.

If this file grows too large, because we are including too many games, we can patch the `csproj` build spec so that `games.json` is not used at build time.
We would also need to patch or disable any tests that rely on it.

## Generating

`games.json` is generated automatically by `update.sh`, using data from [nexusmods' API][url] and the games listed in `game-ids.nix`.

To add a new game to `games.json`:
- Inspect the [nexusmods endpoint][url] to find the game's name and ID
- Add the name and ID to `game-ids.nix`
- Run `update.sh`
- Commit the result

> [!Note]
> Running `update.sh` may also update the existing games, so you may wish to create two separate commits using `git add --patch`.
> One for updating the existing data and another for adding the new game.

[url]: https://data.nexusmods.com/file/nexus-data/games.json

