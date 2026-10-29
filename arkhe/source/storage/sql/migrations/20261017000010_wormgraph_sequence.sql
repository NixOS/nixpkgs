-- Stable append positions for reproducible tenant WormGraph checkpoints.
ALTER TABLE wormgraph_records ADD COLUMN append_sequence bigint GENERATED ALWAYS AS IDENTITY;
CREATE UNIQUE INDEX wormgraph_append_sequence ON wormgraph_records(append_sequence);
GRANT USAGE,SELECT ON SEQUENCE wormgraph_records_append_sequence_seq TO arkhe_append;
