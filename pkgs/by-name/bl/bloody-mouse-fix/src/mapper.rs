use evdev_rs::enums;
use evdev_rs::enums::{EventCode, EventType, EV_MSC};

pub fn map_event_type_to_i32(event_type: &EventType) -> Option<i32> {
    match event_type {
        EventType::EV_KEY => Some(1),
        EventType::EV_REL => Some(2),
        EventType::EV_MSC => Some(4),
        _ => None,
    }
}

pub fn map_key_event_code_to_i32(event_code: &EventCode) -> Option<i32> {
    match event_code {
        EventCode::EV_KEY(e) => match e {
            enums::EV_KEY::BTN_LEFT => Some(272),
            enums::EV_KEY::BTN_RIGHT => Some(273),
            enums::EV_KEY::BTN_MIDDLE => Some(274),
            enums::EV_KEY::BTN_SIDE => Some(275),
            enums::EV_KEY::BTN_EXTRA => Some(276),
            enums::EV_KEY::BTN_FORWARD => Some(277),
            enums::EV_KEY::BTN_BACK => Some(278),
            enums::EV_KEY::BTN_TASK => Some(278),
            _ => None,
        },
        EventCode::EV_REL(e) => match e {
            enums::EV_REL::REL_X => Some(0),
            enums::EV_REL::REL_Y => Some(1),
            enums::EV_REL::REL_WHEEL => Some(8),
            enums::EV_REL::REL_WHEEL_HI_RES => Some(11),
            _ => None,
        },
        EventCode::EV_MSC(e) => match e {
            EV_MSC::MSC_SERIAL => Some(0),
            EV_MSC::MSC_PULSELED => Some(1),
            EV_MSC::MSC_GESTURE => Some(2),
            EV_MSC::MSC_RAW => Some(3),
            EV_MSC::MSC_SCAN => Some(4),
            EV_MSC::MSC_TIMESTAMP => Some(5),
            EV_MSC::MSC_MAX => Some(7),
        },
        _ => None,
    }
}