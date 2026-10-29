pub struct ChannelEnvelope {
    pub channel: String,
    pub authenticated_actor: String,
    pub payload: Vec<u8>,
}

/// Channels transport authenticated requests. They do not authorize.
pub fn transport_only(e: ChannelEnvelope) -> ChannelEnvelope {
    e
}
