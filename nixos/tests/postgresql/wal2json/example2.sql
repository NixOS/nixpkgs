CREATE TABLE table2_with_pk (a SERIAL, b VARCHAR(30), c TIMESTAMP NOT NULL, PRIMARY KEY(a, c));
CREATE TABLE table2_without_pk (a SERIAL, b NUMERIC(5,2), c TEXT);

SELECT 'init' FROM pg_create_logical_replication_slot('test_slot', 'wal2json');

BEGIN;
INSERT INTO table2_with_pk (b, c) VALUES('Backup and Restore', '2018-03-27 12:05:29.914496');
INSERT INTO table2_with_pk (b, c) VALUES('Tuning', '2018-03-27 12:05:29.914496');
INSERT INTO table2_with_pk (b, c) VALUES('Replication', '2018-03-27 12:05:29.914496');

-- Avoid printing wal LSNs since they're not reproducible, so harder to assert on
\o /dev/null
SELECT pg_logical_emit_message(true, 'wal2json', 'this message will be delivered');
SELECT pg_logical_emit_message(true, 'pgoutput', 'this message will be filtered');
\o

DELETE FROM table2_with_pk WHERE a < 3;
\o /dev/null
SELECT pg_logical_emit_message(false, 'wal2json', 'this non-transactional message will be delivered even if you rollback the transaction');
\o

INSERT INTO table2_without_pk (b, c) VALUES(2.34, 'Tapir');
-- it is not added to stream because there isn't a pk or a replica identity
UPDATE table2_without_pk SET c = 'Anta' WHERE c = 'Tapir';
COMMIT;

SELECT data FROM pg_logical_slot_get_changes('test_slot', NULL, NULL, 'pretty-print', '1', 'add-msg-prefixes', 'wal2json');
SELECT 'stop' FROM pg_drop_replication_slot('test_slot');

DROP TABLE table2_with_pk;
DROP TABLE table2_without_pk;
