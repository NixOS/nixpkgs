# Immich {#module-services-immich}

[Immich](https://immich.app/) is a self-hosted photo and video management
solution, similar to SaaS offerings like Google Photos.

## Migrating from `pgvecto-rs` to VectorChord (pre-25.11 installations) {#module-services-immich-vectorchord-migration}

Immich instances that were setup before 25.11 (as in
`system.stateVersion = 25.11;`) will be automatically migrated to VectorChord.
Note that this migration is not reversible, so database dumps should be created
if desired.

See [Immich documentation][vectorchord-migration-docs] for more details about
the automatic migration.

After a successful migration, `pgvecto-rs` should be removed from the database
installation, unless other applications depend on it.

1. Make sure VectorChord is enabled ([](#opt-services.immich.database.enableVectorChord)) and Immich has completed the migration. Refer to the [Immich documentation][vectorchord-migration-docs] for details.
2. Run the following two statements in the PostgreSQL database using a superuser role in Immich's database.

    ```sql
    DROP EXTENSION vectors;
    DROP SCHEMA vectors;
    ```

    - You may use the following command to run these statements against the database: `sudo -u postgres psql immich` (Replace `immich` with the value of [](#opt-services.immich.database.name))

3. Disable `pgvecto-rs` by setting [](#opt-services.immich.database.enableVectors) to `false`.
4. Rebuild and switch.

[vectorchord-migration-docs]: https://immich.app/docs/administration/postgres-standalone/#migrating-to-vectorchord
