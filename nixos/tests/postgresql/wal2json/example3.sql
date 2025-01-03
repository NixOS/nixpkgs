CREATE TABLE table3_with_pk (a SERIAL, b VARCHAR(30), c TIMESTAMP NOT NULL, PRIMARY KEY(a, c));
CREATE TABLE table3_without_pk (a SERIAL, b NUMERIC(5,2), c TEXT);

SELECT 'init' FROM pg_create_logical_replication_slot('test_slot', 'wal2json');

BEGIN;
INSERT INTO table3_with_pk (b, c) VALUES('Backup and Restore', '2019-12-29 04:58:34.806671');
INSERT INTO table3_with_pk (b, c) VALUES('Tuning', '2019-12-29 04:58:34.806671');
INSERT INTO table3_with_pk (b, c) VALUES('Replication', '2019-12-29 04:58:34.806671');
\o /dev/null
SELECT pg_logical_emit_message(true, 'wal2json', 'this message will be delivered');
SELECT pg_logical_emit_message(true, 'pgoutput', 'this message will be filtered');
DELETE FROM table3_with_pk WHERE a < 3;
SELECT pg_logical_emit_message(false, 'wal2json', 'this non-transactional message will be delivered even if you rollback the transaction');
\o

INSERT INTO table3_without_pk (b, c) VALUES(2.34, 'Tapir');
-- it is not added to stream because there isn't a pk or a replica identity
UPDATE table3_without_pk SET c = 'Anta' WHERE c = 'Tapir';
COMMIT;

SELECT data FROM pg_logical_slot_get_changes('test_slot', NULL, NULL, 'format-version', '2', 'add-msg-prefixes', 'wal2json');
SELECT 'stop' FROM pg_drop_replication_slot('test_slot');

DROP TABLE table3_with_pk;
DROP TABLE table3_without_pk;
